feature 'Manage teachers', :devise do

  before do
    sign_in_as_admin
    create_object Teacher, Nachname: 'Meier'
  end

  scenario 'create teacher' do
    click_on 'Referenten'
    click_link 'Neu'
    click_on 'Speichern'
    expect(page).to have_content('Referent konnte nicht gespeichert werden')
  end

  scenario 'edit teacher' do
    click_on 'Referenten'
    click_row_with 'Meier'
    fill_in :Nachname, with: 'Schmidt'
    click_on 'Speichern'
    expect(page).to have_content('Referent gespeichert')
    expect(page).to have_content('Schmidt')
  end

  scenario 'delete teacher' do
    click_on 'Referenten'
    click_row_with 'Meier'
    click_on 'Löschen'
    expect(page).to have_content('Referent gelöscht')
    expect(page).not_to have_content('Meier')
  end

end
