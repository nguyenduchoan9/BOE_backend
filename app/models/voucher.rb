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

  def self.generate(quantity, total)
    for i in 1..quantity
      voucher = Voucher.new
      voucher.save!
      voucher.code = "#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}#{voucher.id}#{rand(1..9)}#{rand(1..9)}"
      voucher.total = total
      voucher.save!
    end
    Voucher.last(quantity)
  end
end
