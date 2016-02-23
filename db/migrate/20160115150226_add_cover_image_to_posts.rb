class AddCoverImageToPosts < ActiveRecord::Migration
  def change
    change_table :wor_posts do |t|
      t.string :cover_image_ext, :null => false, :default => '', :after => :post_type
    end
  end
end
