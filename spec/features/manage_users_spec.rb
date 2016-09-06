feature 'Manage users', :devise do

  before do
    sign_in_as_admin
    create_user 'Benutzername' => 'user1', 'E-Mail' => 'a@b.c', 'Passwort' => '12341234'
  end

  scenario 'create user' do
    click_on 'Benutzer'
    click_link 'Neu'
    click_on 'Speichern'
    expect(page).to have_content('Benutzer konnte nicht gespeichert werden')
  end

  scenario 'edit user' do
    click_on 'Benutzer'
    click_row_with 'user1'
    fill_in :Benutzername, with: 'user2'
    click_on 'Speichern'
    expect(page).to have_content('Benutzer gespeichert')
    expect(page).to have_content('user2')
  end

  scenario 'delete user' do
    click_on 'Benutzer'
    click_row_with 'user1'
    click_on 'Löschen'
    expect(page).to have_content('Benutzer gelöscht')
    expect(page).not_to have_content('user1')
  end

  scenario "can't delete myself" do
    click_on 'Benutzer'
    click_row_with 'testuser'
    click_on 'Löschen'
    expect(page).to have_content('Du kannst dich nicht selber löschen')
    expect(page).to have_content('testuser')
  end

end
