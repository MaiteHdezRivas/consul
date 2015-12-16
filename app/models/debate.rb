require 'numeric'
class Debate < ActiveRecord::Base
  include Flaggable
  include Taggable
  include Conflictable
  include Measurable
  include Sanitizable
  include PgSearch

  apply_simple_captcha
  acts_as_votable
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  belongs_to :author, -> { with_hidden }, class_name: 'User', foreign_key: 'author_id'
  has_many :comments, as: :commentable

  validates :title, presence: true   
  validates :external_link, presence: true, if: :link_required?   
  validates :description, presence: true, if: :description_required?    
  validates :author, presence: true    
           
  validates :title, length: { in: 4..Debate.title_max_length }
  validates :external_link, length: { in: 10..Debate.external_link_max_length }, if: :link_required?  
  validates :external_link, format: { with: /https?:\/\/*/}, if: :link_required?  
  validates :description, length: { in: 10..Debate.description_max_length }, if: :description_required?  

  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create

  before_save :calculate_hot_score, :calculate_confidence_score

  scope :for_render,               -> { includes(:tags) }
  scope :sort_by_hot_score ,       -> { reorder(hot_score: :desc) }
  scope :sort_by_confidence_score, -> { reorder(confidence_score: :desc) }
  scope :sort_by_created_at,       -> { reorder(created_at: :desc) }
  scope :sort_by_most_commented,   -> { reorder(comments_count: :desc) }
  scope :sort_by_random,           -> { reorder("RANDOM()") }
  scope :sort_by_relevance,        -> { all }
  scope :sort_by_flags,            -> { order(flags_count: :desc, updated_at: :desc) }

  # Ahoy setup
  visitable # Ahoy will automatically assign visit_id on create

  pg_search_scope :pg_search, {
    against: {
      title:       'A',
      description: 'B'
    },
    associated_against: {
      tags: :name
    },
    using: {
      tsearch: { dictionary: "spanish" },
    },
    ignoring: :accents,
    ranked_by: '(:tsearch)',
    order_within_rank: "debates.cached_votes_up DESC"
  }

  def description_required? 
    if self.external_link == nil
       return true
    else
      return false
    end  
  end


  def link_required?
    if self.external_link == nil
       return false
    else
      return true
    end
  end
  
  def description
    super.try :html_safe
  end

  def likes
    cached_votes_up
  end

  def dislikes
    cached_votes_down
  end

  def total_votes
    cached_votes_total
  end

  def total_anonymous_votes
    cached_anonymous_votes_total
  end

  def editable?
    total_votes <= Setting.value_for('max_votes_for_debate_edit').to_i
  end

  def editable_by?(user)
    editable? && author == user
  end

  def register_vote(user, vote_value)
    if votable_by?(user)
      Debate.increment_counter(:cached_anonymous_votes_total, id) if (user.unverified? && !user.voted_for?(self))
      vote_by(voter: user, vote: vote_value)
    end
  end

  def votable_by?(user)
    return false unless user
    total_votes <= 100 ||
      !user.unverified? ||
      Setting.value_for('max_ratio_anon_votes_on_debates').to_i == 100 ||
      anonymous_votes_ratio < Setting.value_for('max_ratio_anon_votes_on_debates').to_i ||
      user.voted_for?(self)
  end

  def anonymous_votes_ratio
    return 0 if cached_votes_total == 0
    (cached_anonymous_votes_total.to_f / cached_votes_total) * 100
  end

  def after_commented
    save # updates the hot_score because there is a before_save
  end

  def calculate_hot_score
    self.hot_score = ScoreCalculator.hot_score(created_at,
                                               cached_votes_total,
                                               cached_votes_up,
                                               comments_count)
  end

  def calculate_confidence_score
    self.confidence_score = ScoreCalculator.confidence_score(cached_votes_total,
                                                             cached_votes_up)
  end

  def self.search(terms)
    return none unless terms.present?

    debate_ids = where("debates.title ILIKE ? OR debates.description ILIKE ?",
                       "%#{terms}%", "%#{terms}%").pluck(:id)
    tag_ids = tagged_with(terms, wild: true, any: true).pluck(:id)
    where(id: [debate_ids, tag_ids].flatten.compact)
  end

  def after_hide
    self.tags.each{ |t| t.decrement_custom_counter_for('Debate') }
  end

  def after_restore
    self.tags.each{ |t| t.increment_custom_counter_for('Debate') }
  end

end
