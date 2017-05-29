# == Schema Information
#
# Table name: price_change_histories
#
#  id         :integer          not null, primary key
#  dishes_id  :integer
#  price      :decimal(20, 2)
#  from_date  :datetime         default("2017-05-28 08:08:16.276589")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_price_change_histories_on_dishes_id  (dishes_id)
#

class PriceChangeHistory < ApplicationRecord
  belongs_to :dish, optional: true
end
