feature 'Manage locations', :devise do

  before do
    sign_in_as_admin
    create_object Location, Name: 'VO 1'
  end

  scenario 'create location' do
    click_on 'Veranstaltungsorte'
    click_link 'Neu'
    click_on 'Speichern'
    expect(page).to have_content('Veranstaltungsort konnte nicht gespeichert werden')
  end

  scenario 'edit location' do
    click_on 'Veranstaltungsorte'
    click_row_with 'VO 1'
    fill_in :Name, with: 'VO 2'
    click_on 'Speichern'
    expect(page).to have_content('Veranstaltungsort gespeichert')
    expect(page).to have_content('VO 2')
  end

  scenario 'delete location' do
    click_on 'Veranstaltungsorte'
    click_row_with 'VO 1'
    click_on 'Löschen'
    expect(page).to have_content('Veranstaltungsort gelöscht')
    expect(page).not_to have_content('VO 1')
  end

end
