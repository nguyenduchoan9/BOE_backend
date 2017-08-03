class CreateUserVoucher < ActiveRecord::Migration[5.0]
  def change
    create_table :user_vouchers do |t|
      t.references :user, foreign_key: true
      t.references :voucher, foreign_key: true
    end
  end
end
