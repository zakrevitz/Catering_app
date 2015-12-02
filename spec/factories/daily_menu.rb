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
FactoryGirl.define do
  factory :daily_menu do
    day_number 1
    active true
  end
end