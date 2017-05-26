class CreatePriceChangeHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :price_change_histories do |t|
      t.references :dishes, foreign_key: true
      t.decimal :price, precision: 20, scale: 2
      t.datetime :from_date, default: DateTime.now
      t.timestamps
    end
  end
end
