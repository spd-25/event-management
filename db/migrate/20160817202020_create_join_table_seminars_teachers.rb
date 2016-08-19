class CreateJoinTableSeminarsTeachers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :seminars, :teachers, column_options: { index: true }
    add_foreign_key :seminars_teachers, :seminars, on_delete: :cascade
    add_foreign_key :seminars_teachers, :teachers, on_delete: :cascade
  end
end
