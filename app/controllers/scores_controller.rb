class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scores = Score.all

    @users = []
    @last_assignments = []
    @second_to_last_assignments = []
    @observers = Array.new() { Array.new()}

    @scores.each do |s|
      @users.push(s.trainee.user)
    end

    @users.each_with_index do |u,i|
      @last_assignments.push(u.meta.assignments.last)
      @second_to_last_assignments.push(u.meta.assignments.all[-2])
      #@observers[i].push(Project.find(u.meta.assignments.last.project_id).observers)
    end

    respond_with(@scores)
  end

  def show
    @blocks = @score.assignment.surveys.first.survey_blocks
    @ratings = @score.ratings

    @user = @score.trainee.user
    @last_assignment = @user.meta.assignments.last
    @second_to_last_assignment = @user.meta.assignments.all[-2]
    @observers = Project.find(@last_assignment.project_id).observers

    respond_with(@score)
  end

  def new
    @score = Score.new
    @score.ratings.build
    respond_with(@score)
  end

  def edit
    @blocks = @score.assignment.surveys.first.survey_blocks
    @ratings = @score.ratings

    @user = @score.trainee.user
    @last_assignment = @user.meta.assignments.last
    @second_to_last_assignment = @user.meta.assignments.all[-2]
    @observers = Project.find(@last_assignment.project_id).observers
  end

  def create
    @score = Score.new(score_params)
    @score.save
    respond_with(@score)
  end

  def update

    # pull questions for this score
    questions = @score.assignment.surveys[0].questions

    # init params hash
    update_params = {'ratings_attributes'=>{}}

    # for each questions extract the rating and add to params hash
    questions.each do |q|
      rating = params[q.id.to_s]
      update_params['ratings_attributes'][q.id.to_s] = {'value' => rating.to_s, 'id' => Rating.where(question_id: q.id, score_id: @score.id).first.id.to_s}
    end

    # update score
    respond_to do |format|
      if @score.update(update_params)
        format.html { redirect_to scores_path, notice: 'Scorecard successfully completed' }
        format.json { render :show, status: :ok, location: scores_path }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @score.destroy
    respond_with(@score)
  end

  private
    def set_score
      @score = Score.find(params[:id])
    end

    def score_params
      params[:score]
    end
end
