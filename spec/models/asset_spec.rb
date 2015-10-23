# == Schema Information
#
# Table name: assets
#
#  id             :integer          not null, primary key
#  assetable_id   :integer
#  assetable_type :string
#  filename       :text
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Asset, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
