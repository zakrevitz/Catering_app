# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryGirl.define do
  factory :category do
    title 'Test Category'
    sort_order 1
  end
end