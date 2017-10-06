class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string :subject
      t.text :message
      t.string :path
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
