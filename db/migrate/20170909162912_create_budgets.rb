class CreateBudgets < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.integer :user_id
    	t.integer :category_id
    	t.float :amount, default: 0.0
    	t.float :percent_of_income, default: 0.0
    	t.integer :month, default: 0
    	t.integer :year, default: 0
      t.boolean :recursive, default: false
      t.timestamps
    end
  end
end
