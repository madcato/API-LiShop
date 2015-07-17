class AddIndexApiKeyApiKey < ActiveRecord::Migration
  def change
    add_index :api_keys, :api_key
  end
end
