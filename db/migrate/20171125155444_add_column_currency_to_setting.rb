class AddColumnCurrencyToSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :currency_id, :integer
    add_column :settings, :language, :string
  end
end
