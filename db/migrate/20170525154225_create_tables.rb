class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :tables do |t|
      t.integer :table_number
      t.boolean :status

      t.timestamps
    end
  end
end
