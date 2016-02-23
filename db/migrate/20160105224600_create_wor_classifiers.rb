class CreateWorClassifiers < ActiveRecord::Migration
  def change
    create_table :wor_classifiers do |t|
      t.string  :name
      t.text    :description
      t.string  :slug
      t.string  :classifier_type

      t.timestamps
    end
  end
end
