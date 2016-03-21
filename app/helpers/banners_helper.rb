module BannersHelper
  def banner_style(style)
  	if !style.nil? 
      style.split('.')[1]
    end
  end 
end
