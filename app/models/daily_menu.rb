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

class DailyMenu < ActiveRecord::Base
  validates_presence_of :day_number, :max_total, :dish_ids
  validates :day_number, numericality: { only_integer: true }
  validates :max_total, numericality: true
  validate  :cannot_be_more_than_7_active_menus
  #validates_uniqueness_of :day_number, conditions: -> { where("active = ?", true) }
  validate  :must_be_unique_day_number_for_active_menus
  
  has_many  :daily_rations
  
  before_save :sanitaze_dish_ids

  # Validations
  def cannot_be_more_than_7_active_menus
    if (active == true) && (DailyMenu.where(active: true).count == 7)
      errors.add(:active, "can't be more than 7 active daily menus at once") unless DailyMenu.where(:active => true, :day_number => day_number, :id => id).take
    end
  end

  def must_be_unique_day_number_for_active_menus
    if (active == true) && (DailyMenu.where("active = ? AND day_number= ?", true, day_number).take)
      errors.add(:day_number, "has already been taken") unless DailyMenu.where(:active => true, :day_number => day_number, :id => id).take
    end
  end

  private
    def sanitaze_dish_ids
      self.dish_ids = self.dish_ids.select { |dish| !dish.nil? }
    end
end
