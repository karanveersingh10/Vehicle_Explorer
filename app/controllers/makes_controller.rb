class MakesController < ApplicationController
  def index
    @makes = Make.includes(:vehicles).order(:name)
  end

  def show
    @make = Make.includes(:vehicles).find(params[:id])
  end
end
