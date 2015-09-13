class CompetenciesController < ApplicationController
  before_action :set_competency, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @competencies = Competency.all
    respond_with(@competencies)
  end

  def show
    respond_with(@competency)
  end

  def new
    @competency = Competency.new
    respond_with(@competency)
  end

  def edit
  end

  def create
    @competency = Competency.new(competency_params)
    @competency.save
    respond_with(@competency)
  end

  def update
    @competency.update(competency_params)
    respond_with(@competency)
  end

  def destroy
    @competency.destroy
    respond_with(@competency)
  end

  def import
    Competency.import(params[:file])
    redirect_to competencies_path, notice: "Competencies imported."
  end

  private
    def set_competency
      @competency = Competency.find(params[:id])
    end

    def competency_params
      params.require(:competency).permit(:name, :description, :category, :coaching)
    end
end
