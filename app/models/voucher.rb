# == Schema Information
#
# Table name: vouchers
#
#  id     :integer          not null, primary key
#  total  :decimal(, )
#  code   :string
#  status :boolean          default(TRUE)
#

class Voucher < ApplicationRecord
    has_one :user_voucher
end
