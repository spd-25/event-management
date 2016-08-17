class CreateJoinTableSeminarsTeachers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :seminars, :teachers, column_options: { index: true }
  end
end
