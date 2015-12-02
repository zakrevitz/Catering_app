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
FactoryGirl.define do
  factory :daily_ration do
    sprint     { FactoryGirl.create(:sprint) }
    user       { FactoryGirl.create(:user) }
    dish       { FactoryGirl.create(:meal, category_id: 1) }
    daily_menu { FactoryGirl.create(:daily_menu, dish_ids:[1]) }
    price 20
    quantity 2
  end
end