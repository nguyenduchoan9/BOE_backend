class AddCategoryIdToDish < ActiveRecord::Migration[5.0]
  def change
    add_reference :dishes, :category, foreign_key: true
  end
end
