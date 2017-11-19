class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
    	t.integer :financial_year, default: 1
      t.timestamps
    end
    add_column :users, :setting_id, :integer
    add_index :users, :setting_id
  end
end
