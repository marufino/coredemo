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

    respond_to do |format|
      if @competency.save
        format.html { redirect_to competencies_path, notice: 'Competency was successfully created.' }
        format.json { render :index, status: :created, location: @competency }
      else
        format.html { render :new }
        format.json { render json: @competency.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @competency.update(competency_params)
        format.html { redirect_to competencies_path, notice: 'Competency was successfully updated.' }
        format.json { render :index, status: :ok, location: @competency }
      else
        format.html { render :edit }
        format.json { render json: @competency.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @competency.destroy
    respond_with(@competency)
  end

  def import
    respond_to do |format|
      if Competency.import(params[:file])
        format.html { redirect_to competencies_path, notice: 'Competencies successfully imported.' }
        format.json { render :index, status: :ok, location: @competency }
      else
        format.html { redirect_to competencies_path , alert: 'Wrong formatting. Could not import' }
        format.json { render json: @competency.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_competency
      @competency = Competency.find(params[:id])
    end

    def competency_params
      params.require(:competency).permit(:name, :description, :category, :coaching)
    end
end
