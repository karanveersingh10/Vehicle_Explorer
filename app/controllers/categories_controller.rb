class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:vehicles).order(:name)
  end

  def show
    @category = Category.includes(:vehicles).find(params[:id])
  end
end