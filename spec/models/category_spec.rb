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

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
