# == Schema Information
#
# Table name: orders
#
#  id                          :integer          not null, primary key
#  total                       :decimal(20, 2)
#  discount_date_by_membership :string
#  user_id                     :integer
#  table_number                :integer
#  payment_id                  :string
#  status                      :boolean
#  cooking_status              :integer          default(0)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
