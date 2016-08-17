class CreateSeminars < ActiveRecord::Migration[5.0]
  def change
    create_table :seminars do |t|
      t.string :number, null: false
      t.string :title, null: false
      t.string :subtitle
      t.integer :year, null: false
      t.references :teacher, foreign_key: true
      t.text :benefit
      t.text :content
      t.text :notes
      t.text :due_date
      t.integer :max_attendees
      t.jsonb :others, default: '{}'
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
