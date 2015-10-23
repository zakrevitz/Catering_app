# == Schema Information
#
# Table name: sprints
#
#  id          :integer          not null, primary key
#  title       :text             not null
#  started_at  :datetime
#  finished_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aasm_state  :string
#

class Sprint < ActiveRecord::Base
  include AASM
  aasm :whiny_transitions => false do
    state :pending, :initial => true
    state :started
    state :closed

    event :start do
      transitions :from => :pending, :to => :started
    end

    event :finish do
      transitions :from => :started, :to => :closed
    end
    event :pend do
      transitions :from => :started, :to => :pending
    end
  end

  has_many :daily_rations
end
