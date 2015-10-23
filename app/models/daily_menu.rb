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

  # The old solution to the problem when ActiveAdmin 
  #  didn't save Postgresql Array normally
  # Abandoned due to the need of Text_Array in HTML
  # It was awful and...sickeningly
  # I would not remove it just because it is
  #
  # THE MONUMENT TO THE BICYCLES AND CRUTCHES


  #serialize       :dish_ids, Array
  #attr_accessor   :dish_ids_raw

  #def dish_ids_raw
  #  self.dish_ids.join("\n") unless self.dish_ids.nil?
  #end

  #def dish_ids_raw=(values)
  #  self.dish_ids = []
  #  self.dish_ids=values.split("\n")
  #end

end
