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
FactoryGirl.define do
  factory :sprint do
    title 'xx.xx.xx-xx.xx.xx'
    started_at Faker::Date.forward(1)
    finished_at Faker::Date.forward(8)
  end

  factory :invalid_date_sprint, class: Sprint do
    title 'xx.xx.xx-xx.xx.xx'
    started_at Faker::Date.forward(8)
    finished_at Date.today
  end
end