class AddColumnAttachmentToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_attachment :transactions, :attachment
  end
end
