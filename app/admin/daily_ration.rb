# == Schema Information
#
# Table name: daily_rations
#
#  id            :integer          not null, primary key
#  sprint_id     :integer
#  user_id       :integer
#  daily_menu_id :integer
#  dish_id       :integer
#  price         :float            not null
#  quantity      :integer          default(1), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

ActiveAdmin.register DailyRation do
#actions :all, :except => [:new]
permit_params :price, :quantity, :user_id, :daily_menu_id, :sprint_id,
                :dish_id

  form do |f|
    f.inputs "Daily Ration" do
      f.input :price
      f.input :quantity
      f.input :user_id, as: :select, collection: User.all
      f.input :dish_id, as: :select, collection: Dish.all
      f.input :sprint_id, as: :select, collection: Sprint.all
      f.input :daily_menu_id, as: :select, collection: DailyMenu.pluck(:day_number, :id)
    end
    f.actions
  end


end
