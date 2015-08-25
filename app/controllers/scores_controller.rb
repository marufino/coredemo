class ScoresController < ApplicationController
  include ApplicationHelper
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index

    # pick out all scores for admin, only observer's own for observer
    if current_user.role?('admin')
      @scores = Score.all
    elsif current_user.observer? && !current_user.role?('admin')
      # extract scores from this user's project
      @scores = get_scores_by_observer(current_user.meta)
    end


    @users = []
    @last_assignments = []
    @second_to_last_assignments = []
    @percent_improvements = []
    @observers = Array.new() { Array.new()}

    @scores.each do |s|
      @users.push(s.trainee.user)
    end

    @users.each_with_index do |u,i|

      trainee = u.meta
      last_assignment = trainee.get_nth_assignment(-1)
      second_to_last_assignment = trainee.get_nth_assignment(-2)

      @last_assignments.push(last_assignment)
      @second_to_last_assignments.push(second_to_last_assignment)



      if (last_assignment && second_to_last_assignment)
        @percent_improvements.push(compute_percent_improvement(last_assignment,second_to_last_assignment,trainee))
      end
      #@observers[i].push(Project.find(u.meta.assignments.last.project_id).observers)
    end


    respond_with(@scores)
  end

  def show
    @blocks = @score.assignment.surveys.first.survey_blocks
    @ratings = @score.ratings

    @user = @score.trainee.user
    trainee = @user.meta
    @last_assignment = trainee.get_nth_assignment(-1)
    @second_to_last_assignment = trainee.get_nth_assignment(-2)
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
    trainee = @user.meta
    @last_assignment = trainee.get_nth_assignment(-1)
    @second_to_last_assignment = trainee.get_nth_assignment(-2)
    @observers = Project.find(@last_assignment.project_id).observers


  end

  def create
    @score = Score.new(score_params)
    @score.save
    respond_with(@score)
  end

  def update

    if params[:submit]
      @score.completed = true
      @score.completed_date = Date.today
    end

    # pull questions for this score
    questions = @score.assignment.surveys[0].questions

    # init params hash
    update_params = {'ratings_attributes'=>{}}

    ratings = []
    # for each questions extract the rating and add to params hash
    questions.each do |q|
      rating = params[q.id.to_s]
      update_params['ratings_attributes'][q.id.to_s] = {'value' => rating.to_s, 'id' => Rating.where(question_id: q.id, score_id: @score.id).first.id.to_s}
      ratings << rating
    end

    q_knowledge = 0
    q_skills = 0
    q_abilities = 0
    knowledge = 0
    abilities = 0
    skills= 0
    #generate CORE Scores
    questions.each_with_index do |q,i|
      if q.survey_block.category == 'Knowledge'
        knowledge = knowledge + ratings[i].to_i
        q_knowledge = q_knowledge + 1
      end
      if q.survey_block.category == 'Abilities'
        abilities = abilities + ratings[i].to_i
        q_abilities = q_abilities + 1
      end
      if q.survey_block.category == 'Skills'
        skills = skills + ratings[i].to_i
        q_skills = q_skills + 1
      end
    end

    @score.knowledge  = knowledge / q_knowledge*10
    @score.abilities  = abilities / q_abilities*10
    @score.skills     = skills / q_skills*10
    @score.total      = ratings.map(&:to_f).reduce(:+) / questions.size*10

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
