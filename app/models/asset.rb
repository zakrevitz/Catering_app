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

class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  before_validation :assetable_type
  def assetable_type=(sType)
     super(sType.to_s.classify.constantize.base_class.to_s)
  end
end
