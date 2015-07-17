class ListShouldHaveReceipt < ActiveRecord::Migration
  def change
    add_column :lists, :receipt, :binary
  end
end
