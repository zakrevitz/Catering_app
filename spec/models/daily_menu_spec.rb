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

require 'rails_helper'

RSpec.describe DailyMenu, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
