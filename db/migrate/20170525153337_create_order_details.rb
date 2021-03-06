class CreateOrderDetails < ActiveRecord::Migration[5.0]
    def change
        create_table :order_details do |t|
            t.decimal :price, precision: 20, scale: 2
            t.float :discount_rate_by_day
            t.integer :quantity
            t.integer :quantity_not_serve
            t.integer :quantity_not_served
            t.references :order, foreign_key: true
            t.boolean :status
            t.integer :cooking_status, default: 0
            t.string :description
            t.timestamps
        end
    end
end
