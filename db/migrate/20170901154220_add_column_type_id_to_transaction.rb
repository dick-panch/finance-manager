class AddColumnTypeIdToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :type_id, :integer
  end
end
