class CreateWorPosts < ActiveRecord::Migration
  def change
    create_table :wor_posts do |t|
      t.integer :user_id
      t.string  :slug
      t.string  :title
      t.text    :content
      t.date    :publication_date
      t.string  :status
      t.string  :post_type
      t.string  :permalink
      t.string  :disqus_identifier

      t.timestamps
    end
  end
end
