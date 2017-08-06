class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.float :rating
      t.string :desciption
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
