# == Schema Information
#
# Table name: order_details
#
#  id                   :integer          not null, primary key
#  price                :decimal(20, 2)
#  discount_rate_by_day :float
#  quantity             :integer
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  dishes_id            :integer
#
# Indexes
#
#  index_order_details_on_dishes_id  (dishes_id)
#  index_order_details_on_order_id   (order_id)
#

require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
