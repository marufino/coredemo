
class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
    @survey = Survey.new

    @survey_blocks = []
    @questions = []
    3.times do |i|
      @survey_blocks << @survey.survey_blocks.build
      @questions << @survey_blocks[i].questions.build
    end

    @competencies = Competency.all

  end

  # GET /surveys/1/edit
  def edit
    @competencies = Competency.all
    @survey_blocks = @survey.survey_blocks
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @competencies = Competency.all

    @survey = Survey.new(survey_params)

    @survey.survey_blocks.each_with_index do |s,i|
      s.category = $categorynames[i]
    end

    @survey.survey_blocks.each do |block| block.questions.each do |q|
      q.description = Competency.find_by_name(q.category).description
      end
    end

    respond_to do |format|
      if @survey.save

        if duplicate_competencies
          redirect_to edit_survey_path(@survey), notice: 'There are duplicate Competencies in the Scorecard. Please correct'
          return
        end

        format.html { redirect_to surveys_path, notice: 'Scorecard was successfully created.' }
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end


  def duplicate_competencies
    competencies = []
    for i in 0..2
      survey_params[:survey_blocks_attributes][i.to_s][:questions_attributes].each do |q|
        competencies << q.second[:category]
      end
    end

    if competencies.uniq.length != competencies.length
      return true
    else
      return false
    end

  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    @competencies = Competency.all

    if duplicate_competencies
      redirect_to edit_survey_path(@survey), notice: 'There are duplicate Competencies in the Scorecard. Please correct'
      return
    end

    @survey.survey_blocks.each do |block| block.questions.each do |q|
      q.description = Competency.find_by_name(q.category).description
      end
    end

    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to surveys_path, notice: 'Scorecard was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Scorecard was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params[:survey].permit(:name, :description, :add_question, survey_blocks_attributes: [:id, :category, :weight, questions_attributes:[:id, :category, :weight, :description, :_destroy]])
    end
end
