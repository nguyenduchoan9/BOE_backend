class CreateAllowance < ActiveRecord::Migration[5.0]
  def change
    create_table :allowances do |t|
      t.decimal :total
    end
  end
end