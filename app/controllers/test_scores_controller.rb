class TestScoresController < ApplicationController
  before_action :set_test_score, only: [:edit, :update]


  # GET /test_scores/1/edit
  def edit
    session[:return_to] ||= request.referer
  end


  # PATCH/PUT /test_scores/1
  # PATCH/PUT /test_scores/1.json
  def update
    respond_to do |format|
      if @test_score.update(test_score_params)
        format.html { redirect_to request.referer, notice: 'Test score was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_score }
      else
        format.html { redirect_to request.referer, alert: 'Test score wasn''t successfully updated.' }
        format.json { render json: @test_score.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_score
      @test_score = TestScores.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_score_params
      params.require(:test_scores).permit(:starting, :midterm, :final)
    end
end
