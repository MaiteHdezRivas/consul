class Banner < ActiveRecord::Base
 
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases 

  validates :title, presence: true,
                    length: { minimum: 2 }
  validates :text,  presence: true
  validates :link,  presence: true, format: { with: /https?:\/\/*/}
  validates :style, presence: true

  scope :active,  -> {where("post_started_at <= ?", Time.now).
                      where("post_ended_at >= ?", Time.now) }
end
