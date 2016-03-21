require 'rails_helper'

feature 'Admin add banners' do

  background do
  	banner1 = create(:banner, title: "Banner number one", 
  		            text:  "This is the text of banner number one and is not active yet",
  		            link:  "www.url.com",
  		            style: "banner.banner-one",
  		            post_started_at: (Time.now + 1),
  		            post_ended_at:   (Time.now + 10))
    banner2 = create(:banner, title: "Banner number two", 
  		            text:  "This is the text of banner number two and is not longer active",
  		            link:  "www.url.com",
  		            style: "banner.banner-one",
  		            post_started_at: (Time.now - 10),
  		            post_ended_at:   (Time.now - 1))
    banner3 = create(:banner, title: "Banner number three", 
  		            text:  "This is the text of banner number three and has styee banner-one",
  		            link:  "www.url.com",
  		            style: "banner.banner-one",
  		            post_started_at: (Time.now - 10),
  		            post_ended_at:   (Time.now + 10))
    banner4 = create(:banner, title: "Banner number four", 
  		            text:  "This is the text of banner number four and has styee banner-three",
  		            link:  "www.url.com",
  		            style: "banner.banner-three",
  		            post_started_at: (DateTime.now - 10),
  		            post_ended_at:   (DateTime.now + 10))

    login_as(create(:administrator).user)
  end

  scenario 'Option Publish banners is listed on admin menu' do
    visit admin_root_path

    within('#admin_menu') do
      expect(page).to have_link "Publish banners"
    end
  end

  scenario 'Index show active banners' do
    visit admin_banners_path
    expect(page).to have("There are 4 banners")
  end
end