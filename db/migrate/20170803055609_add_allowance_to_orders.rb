class AddAllowanceToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_reference :orders, :allowance, foreign_key: true
  end
end
