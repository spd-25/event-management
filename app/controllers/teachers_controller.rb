class TeachersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_teacher, only: [:edit, :update, :destroy]

  def index
    authorize Teacher
    @teachers = Teacher.order(:last_name).all
  end

  def new
    authorize Teacher
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    authorize Teacher
    @teacher = Teacher.new teacher_params

    if @teacher.save
      redirect_to teachers_url, notice: t(:created, model: Teacher.model_name.human)
    else
      render :new
    end
  end

  def update
    if @teacher.update teacher_params
      redirect_to teachers_url, notice: t(:updated, model: Teacher.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @teacher.destroy
    redirect_to teachers_url, notice: t(:destroyed, model: Teacher.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_teacher
    @teacher = Teacher.find params[:id]
    authorize @teacher
  end

  # Only allow a trusted parameter "white list" through.
  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name, :profession, :title,
                                    address: %i(street zip city),
                                    contact: %i(email phone mobile fax))
  end
end
