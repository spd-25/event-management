class CategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    authorize Category
    @categories = current_catalog.categories.cat_parents.order(:number)
  end

  def show
  end

  def new
    authorize Category
    @category = Category.new year: current_catalog.year
  end

  def create
    authorize Category
    @category = Category.new category_params

    if @category.save
      redirect_to categories_url, notice: t(:created, model: Category.model_name.human)
    else
      render :new
    end
  end

  def update
    if @category.update category_params
      redirect_to categories_url, notice: t(:updated, model: Category.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: t(:destroyed, model: Category.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = current_catalog.categories.find params[:id]
    authorize @category
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit(:name, :number, :category_id).tap do |p|
      p[:year] = current_catalog.year
    end
  end
end
