class AddDishIdToOrderDetail < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_details, :dishes, foreign_key: true
  end
end
