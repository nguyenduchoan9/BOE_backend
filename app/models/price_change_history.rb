# == Schema Information
#
# Table name: price_change_histories
#
#  id         :integer          not null, primary key
#  dish_id    :integer
#  price      :decimal(20, 2)
#  from_date  :datetime         default("2017-06-01 02:58:00.440744")
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
