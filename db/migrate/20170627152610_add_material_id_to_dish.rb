class AddMaterialIdToDish < ActiveRecord::Migration[5.0]
  def change
  	add_reference :dishes, :material, foreign_key: true
  end
end
