
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
    3.times do
      @survey_blocks = @survey.survey_blocks.build(category: 'Testcat')
      @questions = @survey_blocks.questions.build
    end
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.new(survey_params)

    if params['0']
      @survey.survey_blocks.first.questions.build
    elsif params['1']
      @survey.survey_blocks.second.questions.build
    elsif params['2']
      @survey.survey_blocks.third.questions.build

    elsif params[:remove_question]
      # nested model that have _destroy attribute = 1 automatically deleted by rails
    else
        if @survey.save
          flash[:notice] = "Successfully created survey."
          redirect_to @survey and return
        end
    end
    render :action => 'new'
  end


  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update

    if params[:add_question]
      # rebuild the ingredient attributes that doesn't have an id
      unless params[:survey][:questions_attributes].blank?
        for attribute in params[:survey][:questions_attributes]
          @survey.survey_blocks.first.questions.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty ingredient attribute
      @survey.survey_blocks.first.questions.build
    else
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
    end
      render :action => 'edit'
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Survey was successfully destroyed.' }
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
      params[:survey].permit(:add_question, survey_blocks_attributes: [:category, :weight, questions_attributes:[:category, :weight, :description, :_destroy]])
    end
end
