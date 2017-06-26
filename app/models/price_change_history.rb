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

class PriceChangeHistory < ApplicationRecord
  belongs_to :dish, optional: true

  def self.search(term)
    if term
      where('lower(dishes.dish_name) LIKE ? AND price_change_histories.status = true', "%#{term.downcase}%").includes(:dish).references(:dishes)
    end
  end
end
