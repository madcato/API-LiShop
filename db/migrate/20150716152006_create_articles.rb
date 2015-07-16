class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :list_id
      t.string :name
      t.string :qty
      t.string :category
      t.string :type
      t.string :shop
      t.string :prize
      t.string :checked

      t.timestamps
    end
  end
end
