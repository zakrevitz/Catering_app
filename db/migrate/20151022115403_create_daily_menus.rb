class CreateDailyMenus < ActiveRecord::Migration
  def change
    create_table :daily_menus do |t|
      t.integer :day_number, null: false
      t.float :max_total, default: '100.00'
      t.timestamps null: false
    end
    add_column :daily_menus, :dish_ids, :integer, array: true, default: []
  end
end
