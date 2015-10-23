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

class Category < ActiveRecord::Base
  validates_presence_of :title, :sort_order
  validates :title, length: {maximum: 255}

  has_many :dishes
end
