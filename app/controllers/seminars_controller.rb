class SeminarsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_seminar, only: [:show, :edit, :update, :destroy]

  def index
    authorize Seminar
    @seminars = Seminar.all
  end

  def show
  end

  def new
    authorize Seminar
    @seminar = Seminar.new
  end

  def edit
  end

  def create
    authorize Seminar
    @seminar = Seminar.new seminar_params

    if @seminar.save
      redirect_to @seminar, notice: t(:created, model: Seminar.model_name.human)
    else
      render :new
    end
  end

  def update
    if @seminar.update seminar_params
      redirect_to @seminar, notice: t(:updated, model: Seminar.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @seminar.destroy
    redirect_to seminars_url, notice: t(:destroyed, model: Seminar.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seminar
    @seminar = Seminar.find params[:id]
    authorize @seminar
  end

  # Only allow a trusted parameter "white list" through.
  def seminar_params
    params.require(:seminar).permit(:title, :subtitle, :teacher_id, :benefit, :content, :notes, :max_attendees, :location_id)
  end
end
