# == Schema Information
#
# Table name: dishes
#
#  id          :integer          not null, primary key
#  description :string
#  dish_name   :string
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
# Indexes
#
#  index_dishes_on_category_id  (category_id)
#

class Dish < ApplicationRecord
    belongs_to :category, optional: true
    has_many :order_details
    has_many :price_change_histories

end
