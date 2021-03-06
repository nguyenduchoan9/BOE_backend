class CreatePriceChangeHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :price_change_histories do |t|
      t.references :dish, foreign_key: true
      t.decimal :price, precision: 20, scale: 2
      t.datetime :from_date
      t.boolean :status
      t.timestamps
    end
  end
end
