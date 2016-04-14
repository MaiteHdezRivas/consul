require 'rails_helper'

feature 'Admin add banners' do

  background do
  	@banner1 = create(:banner, title: "Banner number one", 
  		            text:  "This is the text of banner number one and is not active yet",
  		            link:  "http://www.url.com",
  		            style: "banner.banner-one",
  		            post_started_at: (Time.now - 1),
  		            post_ended_at:   (Time.now + 10))

    @banner2 = create(:banner, title: "Banner number two", 
  		            text:  "This is the text of banner number two and is not longer active",
  		            link:  "http://www.url.com",
  		            style: "banner.banner-two",
  		            post_started_at: (Time.now - 10),
  		            post_ended_at:   (Time.now - 1))

    @banner3 = create(:banner, title: "Banner number three", 
  		            text:  "This is the text of banner number three and has styee banner-one",
  		            link:  "http://www.url.com",
  		            style: "banner.banner-three",
  		            post_started_at: (Time.now + 1),
  		            post_ended_at:   (Time.now + 10))

    @banner4 = create(:banner, title: "Banner number four", 
  		            text:  "This is the text of banner number four and has styee banner-three",
  		            link:  "http://www.url.com",
  		            style: "banner.banner-four",
  		            post_started_at: (DateTime.now - 10),
  		            post_ended_at:   (DateTime.now + 10))

    login_as(create(:administrator).user)
  end

  scenario 'Option Publish banners is listed on admin menu' do
    visit admin_root_path

    within('#admin_menu') do
      expect(page).to have_link "Publish banner"
    end
  end

  scenario 'Index show active banners' do
    visit admin_banners_path
    expect(page).to have_content("There are 2 banners")
  end

  scenario 'Refresh changes on edit banner', :js do
    
    visit edit_admin_banner_path(@banner1)

    fill_in 'banner_title', with: 'Titulo modificado'
    fill_in 'banner_text', with: 'Texto modificado'

    within('div#js-banner-style') do
      expect(page).to have_selector('h2', :text => 'Titulo modificado')
      expect(page).to have_selector('h3', :text => 'Texto modificado')
    end
  end
end