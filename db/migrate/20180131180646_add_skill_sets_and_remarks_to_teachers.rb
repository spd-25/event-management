class AddSkillSetsAndRemarksToTeachers < ActiveRecord::Migration[5.1]
  def change
    change_table :teachers do |t|
      t.text :skill_sets
      t.text :remarks
    end
  end
end
