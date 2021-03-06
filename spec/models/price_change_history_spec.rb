# == Schema Information
#
# Table name: price_change_histories
#
#  id         :integer          not null, primary key
#  dish_id    :integer
#  price      :decimal(20, 2)
#  from_date  :datetime
#  status     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_price_change_histories_on_dish_id  (dish_id)
#

require 'rails_helper'

RSpec.describe PriceChangeHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
