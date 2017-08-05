# == Schema Information
#
# Table name: vouchers
#
#  id         :integer          not null, primary key
#  total      :decimal(, )      default(0.0)
#  code       :string
#  status     :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_vouchers_on_user_id  (user_id)
#

class Voucher < ApplicationRecord
  belongs_to :user, optional: true

  def self.generate(quantity, total)
    for i in 1..quantity
      voucher = Voucher.new
      voucher.save!
      voucher.code = "#{rand(0..9)}#{rand(0..9)}#{rand(0..9)}#{voucher.id}#{rand(0..9)}#{rand(0..9)}"
      voucher.total = total
      voucher.save!
    end
    Voucher.last(quantity)
  end
end
