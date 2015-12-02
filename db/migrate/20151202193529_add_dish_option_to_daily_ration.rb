class AddDishOptionToDailyRation < ActiveRecord::Migration
  def change
    add_reference :daily_rations, :dish_option, index: true, foreign_key: true
  end
end
