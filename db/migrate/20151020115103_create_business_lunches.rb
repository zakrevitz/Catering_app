class CreateBusinessLunches < ActiveRecord::Migration
  def change
    create_table :business_lunches do |t|
      t.text :title, null: false
      t.float :price
      t.text :description
      t.timestamps null: false
    end
    add_column :business_lunches, :dish_ids, :integer, array: true, default: []
    add_index :business_lunches, :dish_ids, using: 'gin'
  end
end
