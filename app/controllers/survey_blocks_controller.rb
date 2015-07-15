class SurveyBlocksController < ApplicationController
  before_action :set_survey_block, only: [:show, :edit, :update, :destroy]

  # GET /survey_blocks
  # GET /survey_blocks.json
  def index
    @survey_blocks = SurveyBlock.all
  end

  # GET /survey_blocks/1
  # GET /survey_blocks/1.json
  def show
  end

  # GET /survey_blocks/new
  def new
    @survey_block = SurveyBlock.new
  end

  # GET /survey_blocks/1/edit
  def edit
  end

  # POST /survey_blocks
  # POST /survey_blocks.json
  def create
    @survey_block = SurveyBlock.new(survey_block_params)

    respond_to do |format|
      if @survey_block.save
        format.html { redirect_to @survey_block, notice: 'Survey block was successfully created.' }
        format.json { render :show, status: :created, location: @survey_block }
      else
        format.html { render :new }
        format.json { render json: @survey_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_blocks/1
  # PATCH/PUT /survey_blocks/1.json
  def update
    respond_to do |format|
      if @survey_block.update(survey_block_params)
        format.html { redirect_to @survey_block, notice: 'Survey block was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey_block }
      else
        format.html { render :edit }
        format.json { render json: @survey_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_blocks/1
  # DELETE /survey_blocks/1.json
  def destroy
    @survey_block.destroy
    respond_to do |format|
      format.html { redirect_to survey_blocks_url, notice: 'Survey block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_sign
    @survey_block = SurveyBlock.find(params[:id])
      respond_to do |format|
        format.html { render :sign }
        format.json { head :no_content}
      end
  end

  def sign
    @survey_block = SurveyBlock.find(params[:id])
    @question = Question.find(params[:question_id])

    @question.update_attributes!(:survey_block_id => @survey_block.id)

    respond_to do |format|
      format.html { redirect_to survey_blocks_url, notice: 'Question successfully added to survey' }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_block
      @survey_block = SurveyBlock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_block_params
      params.require(:survey_block).permit(:category, :weight)
    end
end
