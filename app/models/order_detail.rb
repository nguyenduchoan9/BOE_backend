# == Schema Information
#
# Table name: order_details
#
#  id                   :integer          not null, primary key
#  price                :decimal(20, 2)
#  discount_rate_by_day :float
#  quantity             :integer
#  order_id             :integer
#  status               :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  dish_id              :integer
#
# Indexes
#
#  index_order_details_on_dish_id   (dish_id)
#  index_order_details_on_order_id  (order_id)
#

class OrderDetail < ApplicationRecord
	belongs_to :dish, optional: true
	belongs_to :order, optional: true
end
