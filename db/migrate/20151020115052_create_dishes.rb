class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.belongs_to :category, index: true
      t.text :title, null: false
      t.text :description
      t.float :price
      t.timestamps null: false
    end
  end
end
