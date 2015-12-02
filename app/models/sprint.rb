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
class UniqueStartState < ActiveModel::Validator
  def validate(record)
    if (record.aasm_state == 'started') && (Sprint.where(aasm_state: 'started').take)
      record.errors[:name] << 'There can be only one Sprint ongoing'
    end
  end
end

class Sprint < ActiveRecord::Base
  include AASM
  validates_presence_of :title, :started_at, :finished_at
  validates :title, length: {maximum: 255}
  validates :aasm_state, inclusion: { in: %w(pending started closed)}
  validates_with UniqueStartState
  validate :finish_date_cannot_be_before_start_date, :dates_cannot_be_in_the_past

  def finish_date_cannot_be_before_start_date
    if started_at.present? && finished_at.present? && finished_at < started_at
      errors.add(:finished_at, "can't be before started date")
    end
  end

  def dates_cannot_be_in_the_past
    if started_at.present? && started_at < Date.today
      errors.add(:started_at, "can't be in the past")
    end
    if finished_at.present? && finished_at < Date.today
      errors.add(:finished_at, "can't be in the past")
    end
  end

  aasm :whiny_transitions => false do
    state :pending, :initial => true
    state :started
    state :closed

    event :start do
      transitions :from => :pending, :to => :started
    end

    event :close do
      transitions :from => :started, :to => :closed
      transitions :from => :pending, :to => :closed
    end
    # Undo accidentally started sprints
    event :pend do
      transitions :from => :started, :to => :pending
    end
  end

  has_many :daily_rations
end