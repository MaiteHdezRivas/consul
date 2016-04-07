class Admin::BannersController < Admin::BaseController

  before_action :find_banner,  only: [:edit, :update, :destroy]
  before_action :banner_styles, only: [:edit, :new]
  
  respond_to :html, :js

  def index
    @banners = Banner.all.page(params[:page])
  end
  
  def new 
    @banner = Banner.new
  end
    
  def create
    Banner.create(banner_params)
    redirect_to admin_banners_path
  end
  
  def update
    @banner.update(banner_params)
    redirect_to admin_banners_path
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_path
  end

  def banner
    @post_banners = Banner.all.page(params[:page].active)
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
