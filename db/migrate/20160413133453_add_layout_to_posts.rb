class AddLayoutToPosts < ActiveRecord::Migration
  def change
    add_column :wor_posts, :layout, :string, after: :post_type
  end
end
