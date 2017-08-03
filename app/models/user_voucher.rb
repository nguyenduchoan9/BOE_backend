# == Schema Information
#
# Table name: user_vouchers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  voucher_id :integer
#
# Indexes
#
#  index_user_vouchers_on_user_id     (user_id)
#  index_user_vouchers_on_voucher_id  (voucher_id)
#

class UserVoucher < ApplicationRecord
	belongs_to :user
	belongs_to :voucher
end
