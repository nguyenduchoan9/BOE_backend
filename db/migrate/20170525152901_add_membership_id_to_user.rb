class AddMembershipIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :membership, foreign_key: true
  end
end
