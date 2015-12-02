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

class DailyRation < ActiveRecord::Base
  validates_presence_of :sprint_id, 
                        :user_id, 
                        :daily_menu_id,
                        :dish_id, 
                        :price, 
                        :quantity
  validates :price, numericality: { greater_than_or_equal_to: 1}
  validates :quantity, numericality: {greater_than_or_equal_to: 1, only_integer: true }

  belongs_to :dish_option
  belongs_to :sprint
  belongs_to :daily_menu
  belongs_to :dish
  belongs_to :user
end
