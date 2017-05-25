class ChangeStatusInNotes < ActiveRecord::Migration[5.0]
  def change
  	reversible do |dir|
      change_table :notes do |t|
        dir.up {t.change :status, :integer, default: 0}
        dir.down {t.change :status, :integer}
      end
    end
  end
end
