class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :description
      t.date :transaction_date
      t.decimal :amount, default: 0.0
      t.boolean :is_paid, default: false
      t.boolean :is_received, default: false
      t.boolean :is_favorite, default: false
      t.integer :category_id
      t.integer :payment_type_id, default: 1
      t.integer :is_repeat, default: false
      t.integer :transaction_type_id
      t.integer :user_id
      t.integer :month, default: 0
      t.integer :year, default: 0
      t.string :slug
      t.timestamps
    end
    add_index :transactions, :user_id
    add_index :transactions, :category_id
    add_index :transactions, :slug, unique: true
  end
end
