# == Schema Information
#
# Table name: dish_discounts
#
#  id              :integer          not null, primary key
#  dish_id         :integer
#  discount_day_id :integer
#
# Indexes
#
#  index_dish_discounts_on_discount_day_id  (discount_day_id)
#  index_dish_discounts_on_dish_id          (dish_id)
#

class DishDiscount < ApplicationRecord
    belongs_to :dish
    belongs_to :discount_day
end
