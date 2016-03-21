class Admin::BannersController < Admin::BaseController

  before_action :find_banner,   only: [:edit, :update, :destroy]
  before_action :banner_styles, only: [:edit, :new, :update]
  
  respond_to :html, :js

  load_and_authorize_resource

  def index
    @banners = Banner.all.active.page(params[:page])
  end
  
  def new 
    @banner = Banner.new
  end
  
  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to admin_banners_path
    else 
      render new
    end
  end
  
  def update
    @banner.assign_attributes(banner_params)
    if @banner.update(banner_params)
      redirect_to admin_banners_path
    else
      render "edit"
    end
  end
  
  def destroy
    @banner.destroy
    redirect_to admin_banners_path
  end

  private
    def banner_params
      params.require(:banner).permit(:title, :text, :link, :style, :post_started_at, :post_ended_at)
    end

    def find_banner
      @banner = Banner.find(params[:id])
    end 
    
    def banner_styles 
      @banner_styles = Setting.all.banner.map { |banner| [banner.value, banner.key] } 
    end
end
