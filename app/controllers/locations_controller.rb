class LocationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_location, only: [:edit, :update, :destroy]

  def index
    authorize Location
    @locations = Location.order(:name).all
  end

  def new
    authorize Location
    @location = Location.new
  end

  def edit
  end

  def create
    authorize Location
    @location = Location.new location_params

    if @location.save
      redirect_to locations_url, notice: t(:created, model: Location.model_name.human)
    else
      render :new
    end
  end

  def update
    if @location.update location_params
      redirect_to locations_url, notice: t(:updated, model: Location.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_url, notice: t(:destroyed, model: Location.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find params[:id]
    authorize @location
  end

  # Only allow a trusted parameter "white list" through.
  def location_params
    params.require(:location).permit(:name, :description, address: %i(street zip city))
  end
end
