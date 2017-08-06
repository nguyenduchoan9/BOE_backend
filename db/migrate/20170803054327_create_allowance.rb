class CreateAllowance < ActiveRecord::Migration[5.0]
  def change
    create_table :allowances do |t|
      t.decimal :total, default: 0
      t.string :note
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
