class CreateDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :dishes do |t|
      t.string :description
      t.string :dish_name
      t.string :image
      t.boolean :status
      t.boolean :is_available, default: true

      t.timestamps
    end
  end
end
