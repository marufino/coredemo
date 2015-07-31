class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scores = Score.all
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
    num_questions = questions.size

    # init params hash
    update_params = {'ratings_attributes'=>{}}

    # for each questions extract the rating and add to params hash
    (1..num_questions).each do |i|
      rating = params[i.to_s]
      update_params['ratings_attributes'][i.to_s] = {'value' => rating.to_s, 'id' => Rating.where(question_id: questions[i-1].id, score_id: @score.id).first.id.to_s}
    end



    # update score
    @score.update(update_params)
    respond_with(@score)
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
