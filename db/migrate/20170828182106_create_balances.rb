class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.integer :user_id
      t.integer :year
      t.integer :month
      t.float 	:amount
      t.timestamps
    end
  end
end
