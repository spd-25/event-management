class CompaniesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    authorize Company
    @companies = Company.page(params[:page]).all
  end

  def show
  end

  def new
    authorize Company
    @company = Company.new
  end

  def create
    authorize Company
    @company = Company.new company_params

    if @company.save
      redirect_to companies_url, notice: t(:created, model: Company.model_name.human)
    else
      render :new
    end
  end

  def update
    if @company.update company_params
      redirect_to companies_url, notice: t(:updated, model: Company.model_name.human)
    else
      render :show
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url, notice: t(:destroyed, model: Company.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find params[:id]
    authorize @company
  end

  # Only allow a trusted parameter "white list" through.
  def company_params
    params.require(:company).permit(:code, :name, :name2, :street, :zip, :city, :city_part, :phone, :mobile, :fax, :email)
  end
end
