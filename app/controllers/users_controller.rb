class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    authorize User
    @users = User.all
  end

  def new
    authorize User
    @user = User.new
  end

  def edit
  end

  def create
    authorize User
    @user = User.new user_params

    if @user.save
      redirect_to users_url, notice: t(:created, model: User.model_name.human)
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      redirect_to users_url, notice: t(:updated, model: User.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    if @user == current_user
      redirect_to edit_user_url(@user), alert: t('users.cannot_delete_yourself')
    else
      @user.destroy
      redirect_to users_url, notice: t(:destroyed, model: User.model_name.human)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find params[:id]
    authorize @user
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :username, :email, :role, :password, :password_confirmation)
  end
end
