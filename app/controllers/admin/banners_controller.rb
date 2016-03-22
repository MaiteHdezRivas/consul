class Admin::BannersController < Admin::BaseController

  before_action :find_banner,  only: [:edit, :update, :destroy]

  respond_to :html, :js

  def index
    @banners = Banner.all.page(params[:page])
  end

  def create
    Banner.create(banner_params)
    redirect_to admin_banner_path
  end

  def update
    debugger
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
      params.require(:banner).permit(:title, :text, :link, :image, :post_started_at, :post_ended_at)
    end

    def find_banner
      @banner = Banner.find(params[:id])
    end 

end
