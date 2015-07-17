class AddReceiptString < ActiveRecord::Migration
  def change
    add_column :lists, :receipt, :string
  end
end
