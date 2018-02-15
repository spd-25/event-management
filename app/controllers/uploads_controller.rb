class UploadsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_upload, only: %i[show update destroy]

  def index
    authorize Upload
    @uploads = Upload.order(updated_at: :desc).all
  end

  def show
  end

  def new
    authorize Upload
    @upload = Upload.new
  end

  def create
    authorize Upload
    @upload = Upload.new upload_params
    @upload.user = current_user

    if @upload.save
      redirect_to uploads_path, notice: t(:created, model: Upload.model_name.human)
    else
      render :new
    end
  end

  def update
    @upload.assign_attributes upload_params
    @upload.user = current_user

    if @upload.save
      redirect_to uploads_path, notice: t(:updated, model: Upload.model_name.human)
    else
      render :show
    end
  end

  def destroy
    @upload.destroy
    redirect_to uploads_url, notice: t(:destroyed, model: Upload.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_upload
    @upload = Upload.find params[:id]
    authorize @upload
  end

  # Only allow a trusted parameter "white list" through.
  def upload_params
    params.require(:upload).permit(:upload_file, :name)
  end
end
