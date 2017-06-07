class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.float :mark_boundary
      t.float :discount_rate
      t.string :level
      t.boolean :status

      t.timestamps
    end
  end
end
