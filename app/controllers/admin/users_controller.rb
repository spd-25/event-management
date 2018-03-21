module Admin

  class UsersController < BaseController
    before_action :set_user, only: %i[show update destroy seminars]

    def index
      authorize User
      @users = User.all
    end

    def new
      authorize User
      @user = User.new
    end

    def show
    end

    def seminars
      return redirect_to(admin_users_path) unless @user.editor?
      @seminars = @user.edited_seminars.order(:date)
    end

    def create
      authorize User
      @user = User.new user_params

      if @user.save
        redirect_to admin_users_url, notice: t(:created, model: User.model_name.human)
      else
        render :new
      end
    end

    def update
      if @user.update user_params
        redirect_to admin_users_url, notice: t(:updated, model: User.model_name.human)
      else
        render :show
      end
    end

    def destroy
      if @user == current_user
        redirect_to [:admin, @user], alert: t('users.cannot_delete_yourself')
      else
        @user.destroy
        redirect_to admin_users_url, notice: t(:destroyed, model: User.model_name.human)
      end
    end

    def access_rights
      authorize User
      @roles         = User::ROLES - [:user]
      @access_rights = generate_access_rights(@roles)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find params[:id]
      authorize @user
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(
        :name, :username, :email, :role, :password, :password_confirmation, roles: []
      )
    end

    # gives a hash of access rights
    # {
    #   'Seminare' => {
    #     'bearbeiten' => {
    #       'user'  => false,
    #       'admin' => true
    #     }
    #   }
    # }
    def generate_access_rights(roles)
      users = roles.each_with_object({}) { |role, hsh| hsh[role] = User.new roles: [role] }

      standard_actions = { index: 'auflisten', show: 'ansehen', edit: 'bearbeiten' }
      policies = {
        Seminar  => { index: 'auflisten', category: 'nach Themen', date: 'nach Monat', canceled: 'ausgefallen',
                      editing_status: 'Bearbeitungsmodus', show: 'ansehen',
                      edit: ['bearbeiten', Seminar.new(catalog: Catalog.new)],
                      publish: 'veröffentlichen', pras: 'PRAS', versions: 'Änderungen',
                      finish_editing: 'Bearbeitung abschließen', finish_layout: 'Layout abschließen'},
        Attendee => standard_actions.merge(cancel: 'stornieren'),
        Invoice  => standard_actions,
        Catalog  => standard_actions.merge(show: ['ansehen', Catalog.new]),
        Category => standard_actions,
        Location => standard_actions,
        Teacher  => standard_actions,
        Company  => standard_actions,
        User     => standard_actions,
        Upload   => standard_actions,
      }

      _access_rights = {}
      policies.each do |model, actions|
        model_name = model.model_name.human count: 2
        _access_rights[model_name] ||= {}
        actions.each do |action, options|
          action_rights = {}
          title, object = options.is_a?(String) ? [options, model] : options
          roles.each { |role| action_rights[role] = access_right(users[role], object, action) }
          _access_rights[model_name][title] = action_rights
        end
      end
      _access_rights
    end

    def access_right(user, object, action)
      policy = Pundit.policy(user, object)
      policy.send "#{action}?"
    end
  end
end
