class VehiclesController < ApplicationController
  def index
    @vehicles = Vehicle.includes(:make, :categories).order(:model)

    # Search by vehicle model or manufacturer
    if params[:search].present?
      @vehicles = @vehicles.joins(:make).where(
        "vehicles.model LIKE ? OR makes.name LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%"
      )
    end

    # Filter by manufacturer
    if params[:make_id].present?
      @vehicles = @vehicles.where(make_id: params[:make_id])
    end

    # Filter by category
    if params[:category_id].present?
      @vehicles = @vehicles.joins(:categories)
                           .where(categories: { id: params[:category_id] })
    end

   @vehicles = @vehicles.distinct.paginate(page: params[:page], per_page: 20)
   
    @makes = Make.order(:name)
    @categories = Category.order(:name)
  end

  def show
    @vehicle = Vehicle.includes(:make, :categories).find(params[:id])
  end
end