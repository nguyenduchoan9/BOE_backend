class CreateVoucher < ActiveRecord::Migration[5.0]
  def change
    create_table :vouchers do |t|
      t.decimal :total
    end
  end
end
