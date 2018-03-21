module Features
  module SessionHelpers

    def sign_in(username, password)
      visit new_user_session_path
      fill_in User.human_attribute_name(:username), with: username
      fill_in User.human_attribute_name(:password), with: password
      click_button I18n.t('devise.sessions.new.sign_in')
    end

    def sign_out
      click_on @current_user.name, match: :first
      click_on 'Abmelden'
    end

    def sign_in_as_admin
      @current_user = admin = FactoryGirl.create(:user) { |user| user.admin! }
      sign_in(admin.username, admin.password)
      visit admin_root_path
      admin
    end
  end
end
