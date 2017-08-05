# == Schema Information
#
# Table name: vouchers
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  code       :string
#  status     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Voucher < ApplicationRecord
    has_one :user_voucher
end
