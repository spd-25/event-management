class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :seminar, index: true
      t.date :date
      t.string :start_time
      t.string :end_time
      t.references :location, foreign_key: true
      t.string :notes

      t.timestamps
    end
    add_foreign_key :events, :seminars, on_delete: :cascade
  end
end
