class ChangReceiptName < ActiveRecord::Migration
  def change
    remove_column :lists, :receipt
    add_column :lists, :paymentIdentifier, :string
  end
end
