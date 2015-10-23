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

require 'rails_helper'

RSpec.describe DailyRation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
