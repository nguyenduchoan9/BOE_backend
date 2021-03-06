# == Schema Information
#
# Table name: dishes
#
#  id                 :integer          not null, primary key
#  description        :string
#  dish_name          :string
#  dish_name_not_mark :string
#  image              :string
#  status             :boolean
#  is_available       :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  category_id        :integer
#  material_id        :integer
#
# Indexes
#
#  index_dishes_on_category_id  (category_id)
#  index_dishes_on_material_id  (material_id)
#

require 'rails_helper'

RSpec.describe DishesController, type: :controller do

end
