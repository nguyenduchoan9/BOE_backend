class CreateOrderDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_details do |t|
      t.decimal :price, precision: 20, scale: 2
      t.float :discount_rate_by_day
      t.integer :quantity
      t.references :order
      t.boolean :status

      t.timestamps
    end
  end
end
