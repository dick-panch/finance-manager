class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :user_id
      t.integer :category_type_id, default: 1
      t.string :slug
      t.timestamps
    end
    add_index :categories, :user_id
    add_index :categories, :category_type_id
    add_index :categories, :slug
  end
end
