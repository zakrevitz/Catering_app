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

require 'rails_helper'

RSpec.describe DailyRation, type: :model do
  
  context "is valid" do
    it "with all stuff" do
      daily_ration = FactoryGirl.build(:daily_ration)
      expect(daily_ration).to be_valid
    end
  end

  context "is invalid" do
    it "without user" do
      daily_ration = FactoryGirl.build(:daily_ration, user:nil)
      expect(daily_ration).not_to be_valid
    end

    it "without dish" do
      daily_ration = FactoryGirl.build(:daily_ration, dish:nil)
      expect(daily_ration).not_to be_valid
    end

    it "without price" do
      daily_ration = FactoryGirl.build(:daily_ration, price:nil)
      expect(daily_ration).not_to be_valid
    end

    it "without sprint" do
      daily_ration = FactoryGirl.build(:daily_ration, sprint:nil)
      expect(daily_ration).not_to be_valid
    end

    it "without quantity" do
      daily_ration = FactoryGirl.build(:daily_ration, quantity:nil)
      expect(daily_ration).not_to be_valid
    end

    it "without daily_menu" do
      daily_ration = FactoryGirl.build(:daily_ration, daily_menu:nil)
      expect(daily_ration).not_to be_valid
    end
    
    it "with price not Number" do
      daily_ration = FactoryGirl.build(:daily_ration, price: 'String')
      expect(daily_ration).not_to be_valid
    end

    it "with quantity not Integer" do
      daily_ration = FactoryGirl.build(:daily_ration, quantity: 5.36)
      expect(daily_ration).not_to be_valid
    end

    it "with price less than 0 (zero)" do
      daily_ration = FactoryGirl.build(:daily_ration, price: -99)
      expect(daily_ration).not_to be_valid
    end

    it "with quantity less than 0 (zero)" do
      daily_ration = FactoryGirl.build(:daily_ration, quantity: -99)
      expect(daily_ration).not_to be_valid
    end
  end
end
