class AddActiveToDailyMenus < ActiveRecord::Migration
  def change
    add_column :daily_menus, :active, :bool, default: false
  end
end
