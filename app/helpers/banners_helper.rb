module BannersHelper
  def banner_style(style)
    if !style.nil? 
      style.split('.')[1]
    end
  end 

  def has_banners
    @banners.count > 0 
  end 

end
