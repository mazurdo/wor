class AddDateToPosts < ActiveRecord::Migration
  def change
    add_column :wor_posts, :date, :datetime, after: :content
  end
end
