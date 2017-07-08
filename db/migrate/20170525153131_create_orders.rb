class CreateOrders < ActiveRecord::Migration[5.0]
    def change
        create_table :orders do |t|
            t.decimal :total, precision: 20, scale: 2
            t.string :discount_date_by_membership
            t.references :user, foreign_key: true
            t.integer :table_number
            t.boolean :status
            t.integer :cooking_status, default: 0
            t.timestamps
        end
    end
end
