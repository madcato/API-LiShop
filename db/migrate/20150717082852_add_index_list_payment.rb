class AddIndexListPayment < ActiveRecord::Migration
  def change
    add_index :lists, :paymentIdentifier
  end
end
