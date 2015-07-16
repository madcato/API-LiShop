class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :list_id
      t.string :api_key
      t.string :email
      t.boolean :owner

      t.timestamps
    end
  end
end
