class CreateVoucher < ActiveRecord::Migration[5.0]
    def change
        create_table :vouchers do |t|
            t.decimal :total, default: 0
            t.string :code
            t.boolean :status, default: true
            t.references :user

            t.timestamps
        end
    end
end
