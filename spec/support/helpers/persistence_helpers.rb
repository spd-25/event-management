module Features
  module PersistenceHelpers
    def create_object(klass, attributes)
      click_on klass.model_name.human(count: 2)
      click_on 'Neu'
      attributes.each { |name, value| fill_in name, with: value }
      yield if block_given?
      click_on 'Speichern'

      expect(page).to have_content "#{klass.model_name.human} gespeichert"
      attributes.values.each { |value| expect(page).to have_content value }
    end
    alias :given_object :create_object

    def create_user(attributes)
      pw = attributes.delete 'Passwort'
      create_object User, attributes do
        ['', '_confirmation'].each { |field| fill_in "user[password#{field}]", with: pw }
      end
    end
    alias :given_user :create_user

  end
end
