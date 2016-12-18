class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :code
      t.string :name
      t.string :name2
      t.string :street
      t.string :zip
      t.string :city
      t.string :city_part
      t.string :phone
      t.string :mobile
      t.string :fax
      t.string :email

      t.timestamps
    end
  end
end
