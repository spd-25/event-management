class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :title, null: false, unique: true
      t.string :slug,  null: false, unique: true
      t.text :teaser
      t.text :content
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
