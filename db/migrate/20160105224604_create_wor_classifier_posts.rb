class CreateWorClassifierPosts < ActiveRecord::Migration
  def change
    create_table :wor_classifier_posts do |t|
      t.integer :post_id
      t.integer :classifier_id

      t.timestamps
    end
  end
end
