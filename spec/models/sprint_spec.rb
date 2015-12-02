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

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Sprint, type: :model do
  context 'is valid' do
    it "with a title, started, finished dates" do
      sprint = FactoryGirl.build(:sprint)
      expect(sprint).to be_valid
    end
    it "without aasm_state" do
      sprint = FactoryGirl.build(:sprint)
      expect(sprint).to have_state(:pending)
      expect(sprint).to be_valid
    end
  end

  context 'is invalid' do
    it "without a title" do
      sprint = FactoryGirl.build(:sprint, title: nil)
      expect(sprint).not_to be_valid
    end

    it "with long title" do
      sprint = FactoryGirl.build(:sprint, title: "Ski bi di bi di do bap do 
                                                  Do bam do 
                                                  Bada bwi ba ba bada bo 
                                                  Baba ba da bo 
                                                  Bwi ba ba ba do
                                                  I'm a scatman" * 5)
      expect(sprint).not_to be_valid
    end

    it "without a started date" do
      sprint = FactoryGirl.build(:sprint, started_at: nil)
      expect(sprint).not_to be_valid
    end

    it "without a finished date" do
      sprint = FactoryGirl.build(:sprint, finished_at: nil)
      expect(sprint).not_to be_valid
    end

    it "with finished date before started date" do
      sprint = FactoryGirl.build(:invalid_date_sprint)
      expect(sprint).not_to be_valid
    end

    it "with started date in the past" do
      sprint = FactoryGirl.build(:sprint, started_at: Faker::Date.backward(7))
      expect(sprint).not_to be_valid
    end

    it "with finished date in the past" do
      sprint = FactoryGirl.build(:sprint, finished_at: Faker::Date.backward(7))
      expect(sprint).not_to be_valid
    end

    it "with state not in {'started', 'closed', 'pending'}" do
      sprint = FactoryGirl.build(:sprint, aasm_state: 'test')
      expect(sprint).not_to be_valid
    end
  end

  it "has unique 'Started' state" do
    started_sprint = FactoryGirl.create(:sprint, aasm_state: 'started')
    sprint = FactoryGirl.build(:sprint, aasm_state: 'started')
    expect(sprint).not_to be_valid
  end

  it "state machine is working" do
    sprint = FactoryGirl.build(:sprint)
    expect(sprint).to have_state(:pending)
    expect(sprint).to_not allow_event :pend
    expect(sprint).to allow_event :start
    expect(sprint).to allow_event :close
    expect(sprint).to transition_from(:pending).to(:started).on_event(:start)
    expect(sprint).to_not allow_event :start
    expect(sprint).to allow_event :pend
    expect(sprint).to allow_event :close
    expect(sprint).to transition_from(:started).to(:pending).on_event(:pend)
    expect(sprint).to allow_event :close
    expect(sprint).to transition_from(:pending).to(:closed).on_event(:close)
    expect(sprint).to_not allow_event :start
    expect(sprint).to_not allow_event :pend
    expect(sprint).to_not allow_event :close
  end
end
