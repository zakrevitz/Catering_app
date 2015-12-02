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
#  active     :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe DailyMenu, type: :model do

  let(:category)    { FactoryGirl.build(:category) }
  let(:first_dish)  { FactoryGirl.build(:meal, category: category) }
  let(:second_dish) { FactoryGirl.build(:meal, category: category, title: "Raw kartoshka") }

  context 'is valid' do
    it "with a day number, max total and array of dish_ids" do
      daily_menu = FactoryGirl.build(:daily_menu)
      daily_menu.dish_ids = [first_dish.id, second_dish.id]
      expect(daily_menu).to be_valid
    end

    it "and max total is 100.00 by default" do
      daily_menu = FactoryGirl.build(:daily_menu)
      daily_menu.dish_ids = [first_dish.id, second_dish.id]
      expect(daily_menu.max_total).to eq(100.00)
      expect(daily_menu).to be_valid
    end

    it "with not unique day number for not active daily menu" do
      older_daily_menu = FactoryGirl.create(:daily_menu, active: true, day_number: 1, dish_ids: [first_dish.id,second_dish.id])
      daily_menu = FactoryGirl.create(:daily_menu, active: false, day_number: 1, dish_ids: [1,2])
      second_daily_menu = FactoryGirl.build(:daily_menu, active: false, day_number: 1, dish_ids: [1,2])
      expect(daily_menu).to be_valid
      expect(second_daily_menu).to be_valid
    end
    it "with not unique day number for not active daily menu" do
      older_daily_menu = FactoryGirl.create(:daily_menu, active: false, day_number: 1, dish_ids: [first_dish.id,second_dish.id])
      daily_menu = FactoryGirl.build(:daily_menu, active: true, day_number: 1, dish_ids: [1,2])
      expect(daily_menu).to be_valid
    end
  end
  context 'is invalid' do
    it "without a day number" do
      daily_menu = FactoryGirl.build(:daily_menu, day_number: nil)
      daily_menu.dish_ids = [first_dish.id, second_dish.id]
      expect(daily_menu).not_to be_valid
    end

    it "with a day number not Integer" do
      daily_menu = FactoryGirl.build(:daily_menu, day_number: 10.5)
      daily_menu.dish_ids = [first_dish.id, second_dish.id]
      expect(daily_menu).not_to be_valid
    end

    it "with max total not Number" do
      daily_menu = FactoryGirl.build(:daily_menu, max_total: 'String')
      daily_menu.dish_ids = [first_dish.id, second_dish.id]
      expect(daily_menu).not_to be_valid
    end

    it "without a max total" do
      daily_menu = FactoryGirl.build(:daily_menu, max_total: nil)
      daily_menu.dish_ids = [first_dish.id, second_dish.id]
      expect(daily_menu).not_to be_valid
    end

    it "without a dish_ids" do
      daily_menu = FactoryGirl.build(:daily_menu)
      expect(daily_menu).not_to be_valid
    end

    it "when there is 7 other active daily menus" do
      7.times do |i|
        FactoryGirl.create(:daily_menu, day_number: i, dish_ids: [first_dish.id, second_dish.id])
      end
      daily_menu = FactoryGirl.build(:daily_menu, day_number: 99, dish_ids: [first_dish.id, second_dish.id])
      expect(daily_menu).not_to be_valid
    end
  end

  it "has a unique day number" do
    older_daily_menu = FactoryGirl.create(:daily_menu, dish_ids: [first_dish.id,second_dish.id])
    daily_menu = FactoryGirl.build(:daily_menu, dish_ids: [first_dish.id,second_dish.id])
    expect(daily_menu).not_to be_valid
  end

end
