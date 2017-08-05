# == Schema Information
#
# Table name: allowances
#
#  id         :integer          not null, primary key
#  total      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer
#
# Indexes
#
#  index_allowances_on_order_id  (order_id)
#

class Allowance < ApplicationRecord
	belongs_to :order
end
