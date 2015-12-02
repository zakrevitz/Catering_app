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

RSpec.describe Dish, type: :model do
  let(:category) {FactoryGirl.create(:category)}
  context 'is valid' do
    it "with a title, description and price" do
      meal = FactoryGirl.build(:meal, category: category)
      expect(meal).to be_valid
    end

    it "without a description" do
      meal = FactoryGirl.build(:meal, category: category, description: nil)
      expect(meal).to be_valid
    end
  end
  context 'is invalid' do
    it "with long description" do
      meal = FactoryGirl.build(:meal, category: category, description: "Test" * 1000)
      expect(meal).not_to be_valid
    end

    it "without a title" do
      meal = FactoryGirl.build(:meal, category: category, title: nil)
      expect(meal).not_to be_valid
    end

    it "without a category" do
      meal = FactoryGirl.build(:meal, category: nil)
      expect(meal).not_to be_valid
    end

    it "without a price" do
      meal = FactoryGirl.build(:meal, category: category, price: nil)
      expect(meal).not_to be_valid
    end

    it "with price not Number" do
      meal = FactoryGirl.build(:meal, price: 'String')
      expect(meal).not_to be_valid
    end

    it "with long title" do
      meal = FactoryGirl.build(:meal, category: category, title: "Ski bi di bi di do bap do 
                                                                  Do bam do 
                                                                  Bada bwi ba ba bada bo 
                                                                  Baba ba da bo 
                                                                  Bwi ba ba ba do
                                                                  I'm a scatman" * 5)
      expect(meal).not_to be_valid
    end
  end
end
