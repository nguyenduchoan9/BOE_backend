# == Schema Information
#
# Table name: allowances
#
#  id         :integer          not null, primary key
#  total      :decimal(, )      default(0.0)
#  note       :string
#  order_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_allowances_on_order_id  (order_id)
#

class Allowance < ApplicationRecord
	belongs_to :order
end
