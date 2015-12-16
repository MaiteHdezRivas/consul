class DebateLinksController < ApplicationController
  include CommentableActions
  include FlagActions

  before_action :parse_search_terms, only: :index
  before_action :parse_tag_filter, only: :index
  before_action :authenticate_user!, except: [:index, :show]

  has_orders %w{hot_score confidence_score created_at most_commented random}, only: :index
  has_orders %w{most_voted newest oldest}, only: :show


  load_and_authorize_resource class: "Debate"
  respond_to :html, :js

  def vote
    @debate.register_vote(current_user, params[:value])
    set_debate_votes(@debate)
  end

  def after_create_path
    debate_path(@resource)   
  end

  private
    def create_params
      params.require(:debate).permit(:title, :external_link, :tag_list, :terms_of_service, :captcha, :captcha_key)
    end        
    def debate_params
      params.require(:debate).permit(:title, :external_link, :tag_list, :terms_of_service, :captcha, :captcha_key)
    end
    def resource_model
      Debate
    end

end
