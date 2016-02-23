class CreateWorComments < ActiveRecord::Migration
  def change
    create_table :wor_comments do |t|
      t.integer   :post_id
      t.string    :username
      t.text      :message
      t.datetime  :created_at
      t.text      :disqus_object
    end
  end
end
