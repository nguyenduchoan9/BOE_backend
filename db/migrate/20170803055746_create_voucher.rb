class CreateVoucher < ActiveRecord::Migration[5.0]
  def change
    create_table :vouchers do |t|
      t.decimal :total
      t.string :code
      t.boolean :status, default: true
    end
  end
end
