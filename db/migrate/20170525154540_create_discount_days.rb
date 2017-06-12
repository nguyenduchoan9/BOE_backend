class CreateDiscountDays < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_days do |t|
      t.date :from_day
      t.date :to_day
      t.text :discount_item
      t.string :name
      t.string :image
      t.float :discount_rate
      t.boolean :status

      t.timestamps
    end
  end
end
