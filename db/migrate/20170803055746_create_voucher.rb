class CreateVoucher < ActiveRecord::Migration[5.0]
    def change
        create_table :vouchers do |t|
            t.decimal :total, default: 0
            t.string :code
            t.boolean :status, default: true
            t.references :user, foreign_key: true

            t.timestamps
        end
    end
end
