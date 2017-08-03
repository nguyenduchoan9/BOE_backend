# == Schema Information
#
# Table name: vouchers
#
#  id    :integer          not null, primary key
#  total :decimal(, )
#

class Voucher < ApplicationRecord
    has_one :user_voucher
end
