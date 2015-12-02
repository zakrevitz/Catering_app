# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean
#
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name 'Ivan'
    password '12345678'
    password_confirmation { '12345678'}
    sign_in_count 0
    failed_attempts 0
  end

  factory :admin, class: User do
    email { Faker::Internet.email }
    name 'admin'
    password '12345678'
    password_confirmation { '12345678'}
    sign_in_count 0
    failed_attempts 0
    admin true
  end
end