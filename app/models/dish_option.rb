class DishOption < ActiveRecord::Base
  has_many :daily_rations
  belongs_to :dish_with_option
end