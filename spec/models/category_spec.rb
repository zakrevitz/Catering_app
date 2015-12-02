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

require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'is valid' do
    it "with a title and sort order" do
      category = FactoryGirl.build(:category)
      expect(category).to be_valid
    end
  end
  
  context 'is invalid' do
    it "without a title" do
      category = FactoryGirl.build(:category, title: nil)
      expect(category).not_to be_valid
    end

    it "without sort order" do
      category = FactoryGirl.build(:category, sort_order: nil)
      expect(category).not_to be_valid
    end

    it "with sort order not Integer" do
      category = FactoryGirl.build(:category, sort_order: 10.29)
      expect(category).not_to be_valid
    end
  end
end
