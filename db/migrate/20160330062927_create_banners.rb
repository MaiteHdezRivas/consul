class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string 		:title,  limit: 80
	    t.string 		:text
	    t.string 		:link    
	    t.string 		:style
	    t.datetime	:post_started_at
	    t.datetime 	:post_ended_at

      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
