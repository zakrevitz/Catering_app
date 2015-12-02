# == Schema Information
#
# Table name: dishes
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  title        :text             not null
#  description  :text
#  price        :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  type         :string(45)
#  children_ids :integer          default([]), is an Array
#

require 'rails_helper'

RSpec.describe BusinessLunch, type: :model do

  let(:category) {FactoryGirl.create(:category, title: "Test Business Lunch")}

  it "is valid with a title, description and price and children_ids" do
    @category_meal = FactoryGirl.create(:category)
    @first_dish = FactoryGirl.create(:meal, category: @category_meal)
    @second_dish = FactoryGirl.create(:meal, category: @category_meal, title: "Raw kartoshka")
    business_lunch = FactoryGirl.build(:business_lunch, category: category)
    business_lunch.children_ids = [@first_dish.id, @second_dish.id]
    expect(business_lunch).to be_valid
  end

  it "is invalid without children_ids" do
    business_lunch = FactoryGirl.build(:business_lunch, category: category, children_ids: nil)
    expect(business_lunch).not_to be_valid
  end
end
