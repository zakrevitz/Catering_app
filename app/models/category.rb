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
  default_scope { order('sort_order ASC') }
  
  validates_presence_of :title, :sort_order
  validates :title, length: {maximum: 255}
  validates :sort_order, numericality: { only_integer: true }

  has_many :dishes
end
