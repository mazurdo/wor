class AddSeoDescription < ActiveRecord::Migration
  def change
    add_column :wor_posts, :seo_description, :text, after: :content
  end
end
