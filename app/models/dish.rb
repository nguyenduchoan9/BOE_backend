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
end
