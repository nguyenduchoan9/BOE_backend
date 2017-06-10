# == Schema Information
#
# Table name: dishes
#
#  id          :integer          not null, primary key
#  description :string
#  dish_name   :string
#  image       :string
#  status      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
# Indexes
#
#  index_dishes_on_category_id  (category_id)
#

require 'rails_helper'

RSpec.describe Dish, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
