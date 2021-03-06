# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
    validates :name, inclusion: { in: %w(diner manager admin chef waiter cashier) }
    validates :name, uniqueness: true
    validates :name, presence: true

    has_many :users
end
