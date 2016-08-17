class CreateTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :profession
      t.jsonb :address, default: '{}'
      t.jsonb :contact, default: '{}'

      t.timestamps
    end
  end
end
