class CreateDishOptions < ActiveRecord::Migration
  def change
    create_table :dish_options do |t|
      t.belongs_to :dish_with_option, index: true
      t.text :title, null: false
      t.float :price, null: false
      t.timestamps null: false
    end
  end
end
