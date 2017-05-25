class ChangeNotes < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      change_table :notes do |t|
        dir.up {t.change :status, :integer}
        dir.down {t.change :status, :integer, default: 0}
      end
    end
  end
end
