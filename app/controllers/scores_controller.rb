class ScoresController < ApplicationController
  include ApplicationHelper
  before_action :set_score, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:destroy]
  before_action :owns_score, only: [:show, :edit]
  before_action :owns_scores, only: [:index]


  def index

    @curr_page_scores = true

    # parameter to decide whether to show cards or table
    @cards = false
    @cards = params[:cards]

    # pick out all scores based on filterrific params
    @filterrific = initialize_filterrific(
        Score,
        params[:filterrific],
        :select_options => {
            sorted_by: Score.options_for_sorted_by,
            with_trainee_id: Trainee.options_for_select,
            with_survey: Survey.options_for_select,
            with_observer_id: Observer.options_for_select,
            with_project: Project.options_for_select,
            with_area_of_strength: Competency.options_for_select,
            with_area_of_weakness: Competency.options_for_select
        }
    ) or return
    @scores_all = @filterrific.find
    @scores = @filterrific.find.page(params[:page])

    # if cards only show last two weeks and not completed scores
    if @cards
      @scores = @scores.where(:completed => false).where(:assigned_date =>  15.days.ago..Date.today()+15).order(:assigned_date)
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


    respond_to do |format|
      format.html
      format.js
      format.xls
    end

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
    @score.build_area_of_weakness
    @score.build_area_of_strength
    respond_with(@score)
  end

  def edit

    @curr_page_score_edit = true
    @blocks = @score.assignment.surveys.first.survey_blocks
    @ratings = @score.ratings

    @user = @score.trainee.user
    trainee = @user.meta
    @last_assignment = trainee.get_nth_assignment(-1)
    @second_to_last_assignment = trainee.get_nth_assignment(-2)
    @observers = Project.find(@last_assignment.project_id).observers

    @competencies = []
    @blocks.each do |block|
      block.questions.each_with_index do |q|
        @competencies.push(Competency.find_by(:name => q.category))
      end
    end

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

    ratings = []
    # for each questions extract the rating and add to params hash
    questions.each do |q|

      rating = params[q.id.to_s]
      update_params['ratings_attributes'][q.id.to_s] = {'value' => rating.to_s, 'id' => Rating.where(question_id: q.id, score_id: @score.id).first.id.to_s}
      ratings << rating
    end

    @score.comments = params['comments']

    # update score
    respond_to do |format|
      if @score.update(update_params)

        if params[:submit]

          @score.completed = true
          @score.completed_date = DateTime.now


          if !@score.filled_out?
            redirect_to edit_score_path(@score), alert: "Please rate all competencies before submitting Scorecard"
            return
          end

          @score.calculate_scores(ratings,questions)

          @score.save
        end

        format.html { redirect_to scores_path, notice: 'Scorecard successfully' + if params[:submit] then ' Completed' else ' Saved' end }
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

    def check_admin
      redirect_to current_user unless current_user.admin?
    end

    def owns_score
      if !current_user.admin?
        redirect_to current_user unless Score.find(params['id']).trainee_id == current_user.meta.id
      end
    end

    def owns_scores

      if !current_user.admin?
        if current_user.trainee?
          redirect_to current_user unless params['filterrific']['with_trainee_id'].to_i == current_user.meta.id
        elsif current_user.observer?
          redirect_to current_user unless params['filterrific']['with_observer_id'].to_i == current_user.meta.id
        end
      end

    end

  end

