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

class Dish < ActiveRecord::Base
  validates_presence_of :title, :price, :description
  validates :title, length: {maximum: 255}
  validates :price, length: {maximum: 30}, numericality: true
  validates :description, length: {maximum: 65536}

  has_many :daily_rations
  belongs_to :category
  #has_one :image, :as => :assetable, :dependent => :destroy
  #accepts_nested_attributes_for :image
end
