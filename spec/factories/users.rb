# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ipd    :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  full_name              :string
#  avatar                 :string
#  email                  :string           default("email@gmail.com")
#  username               :string
#  access_token           :string
#  birthdate              :string
#  mark                   :float            default("0.0")
#  phone                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer
#  membership_id          :integer
#
# Indexes
#
#  index_users_on_membership_id         (membership_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username)
#

FactoryGirl.define do
  factory :user do
    email 'user@gmail.com'
    first_name Faker::Name.first_name
    password 'a' * 10
    uid { generate(:user_uid) }
    # role_id 1
  end

  factory :staff, class: User do
    email 'staff@gmail.com'
    first_name Faker::Name.first_name
    password 'b' * 10
    uid { generate(:user_uid) }
  end

  sequence :user_email do |n|
    "user_email_#{n}@gmail.com"
  end

  sequence :user_uid do |n|
    "user_uid_#{n}"
  end

  factory :factory_user, class: User do
    email { generate(:user_email) }
    first_name Faker::Name.first_name
    password Faker::Lorem.characters(10)
    uid { generate(:user_uid) }
  end
end
