class AddOrderToAllowances < ActiveRecord::Migration[5.0]
  def change
  	add_reference :allowances, :order, foreign_key: true
  end
end
