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
#

class DailyMenu < ActiveRecord::Base
  has_many :daily_rations
  before_save :sanitaze_dish_ids

  private
    def sanitaze_dish_ids
      self.dish_ids = self.dish_ids.select { |dish| !dish.nil? }
    end
end
