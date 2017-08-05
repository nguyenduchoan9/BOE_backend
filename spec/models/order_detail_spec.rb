# == Schema Information
#
# Table name: order_details
#
#  id                   :integer          not null, primary key
#  price                :decimal(20, 2)
#  discount_rate_by_day :float
#  quantity             :integer
#  quantity_not_serve   :integer
#  quantity_not_served  :integer
#  order_id             :integer
#  status               :boolean
#  cooking_status       :integer          default(0)
#  description          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  dish_id              :integer
#
# Indexes
#
#  index_order_details_on_dish_id   (dish_id)
#  index_order_details_on_order_id  (order_id)
#

require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
