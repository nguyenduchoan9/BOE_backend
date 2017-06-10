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
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ipd    :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  full_name              :string
#  avatar                 :string
#  email                  :string
#  username               :string
#  access_token           :string
#  reg_token              :string
#  birthdate              :string
#  mark                   :float            default(0.0)
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

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :omniauthable
  # :confirmable, , :token_authenticatable

  include DeviseTokenAuth::Concerns::User

  validates :username, uniqueness: {message: 'taken'}
  # validates :first_name, presence: true
  validates :password, confirmation: true

  belongs_to :role, optional: true
  belongs_to :membership, optional: true

  has_many :orders
  # validates :email, uniqueness: {message: 'taken'}
  # validates :first_name, presence: true


  def self.search(term)
    if term
      where('lower(full_name) LIKE ?', "%#{term.downcase}%")
    else
      all
    end
  end
end
