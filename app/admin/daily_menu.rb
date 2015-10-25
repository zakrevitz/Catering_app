# == Schema Information
#
# Table name: daily_menus
#
#  id         :integer          not null, primary key
#  day_number :integer          not null
#  max_total  :float            default(100.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dish_ids   :integer          default([]), is an Array
#

ActiveAdmin.register DailyMenu do
 permit_params :day_number, :max_total, dish_ids:[]
 form do |f|
  f.inputs "Dish ids" do
    f.input :day_number, :as => :radio, :collection => ["1", "2", "3", "4", "5", "6", "7"]
    f.input :max_total
    f.input :dish_ids, :as => :select, :collection => Dish.all, :input_html => {:multiple => true}
  end
  actions
 end

end
