class CreateDishDiscount < ActiveRecord::Migration[5.0]
  def change
    create_table :dish_discounts do |t|
      t.references :dish, foreign_key: true
      t.references :discount_day, foreign_key: true
    end
  end
end
