# == Schema Information
#
# Table name: price_change_histories
#
#  id         :integer          not null, primary key
#  dish_id    :integer
#  price      :decimal(20, 2)
#  from_date  :datetime         default(Mon, 12 Jun 2017 01:24:59 UTC +00:00)
#  status     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_price_change_histories_on_dish_id  (dish_id)
#

class PriceChangeHistory < ApplicationRecord
  belongs_to :dish, optional: true
end
