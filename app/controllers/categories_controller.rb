class CategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    authorize Category
    @categories = Category.cat_parents.order(:name)
  end

  def new
    authorize Category
    @category = Category.new
  end

  def edit
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
    @category = Category.find params[:id]
    authorize @category
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit(:name, :category_id)
  end
end
