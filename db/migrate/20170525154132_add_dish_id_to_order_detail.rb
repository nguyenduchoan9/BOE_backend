class AddDishIdToOrderDetail < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_details, :dish, foreign_key: true
  end
end
