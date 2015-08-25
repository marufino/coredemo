class UsersController < ApplicationController
  include ApplicationHelper
  respond_to :html, :json


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show

    @user = User.find(params[:id])

    if @user.trainee?

      @trainee = @user.meta
      @last_assignment = @trainee.get_nth_assignment(-1)
      @second_to_last_assignment = @trainee.get_nth_assignment(-2)

      if @last_assignment && @second_to_last_assignment
        @observers = Project.find(@last_assignment.project_id).observers
        @percent_improvement = compute_percent_improvement(@last_assignment, @second_to_last_assignment, @trainee)
      end

      @graph = graph_scores_for_trainee(@trainee)

    elsif @user.observer? & !@user.role?('admin')
      # get next scorecard to be completed by this observer
      scores = get_scores_by_observer(@user.meta)


        # date for survey/profile card
        @score = scores.first

      if @score
        @trainee = @score.trainee
        @last_assignment = @trainee.get_nth_assignment(-1)
        @second_to_last_assignment = @trainee.get_nth_assignment(-2)


        # get all trainees under this observer
        @trainees = get_trainees_by_observer(@user.meta)

        if @last_assignment && @second_to_last_assignment
          @observers = Project.find(@last_assignment.project_id).observers
          @percent_improvement = compute_percent_improvement(@last_assignment, @second_to_last_assignment, @trainee)
        end

        # generate graph
        @graph = graph_scores_for_trainee(@trainee)
      end


    elsif @user.role?('admin')

      # get last N(10) completed scores
      @scores = Score.where(:completed => 't').order(completed_date: :asc).limit(10)

      @users = []
      @last_assignments = []
      @second_to_last_assignments = []
      @percent_improvements = []
      @observers = Array.new() { Array.new()}

      # populate profile cards based on scores
      @scores.each do |s|
        @users.push(s.trainee.user)
      end

      @users.each_with_index do |u,i|

        trainee = u.meta
        last_assignment = trainee.get_nth_assignment(-1)
        second_to_last_assignment = trainee.get_nth_assignment(-2)

        @last_assignments.push(last_assignment)
        @second_to_last_assignments.push(second_to_last_assignment)

        if last_assignment && second_to_last_assignment
          @percent_improvements.push(compute_percent_improvement(last_assignment,second_to_last_assignment,trainee))
        end
        #@observers[i].push(Project.find(u.meta.assignments.last.project_id).observers)
      end

      # generate graph
      @graph = graph_scores_for_trainee(@users.first.meta)

      # scores completed this month
      month_scores = Score.where(completed_date: Date.today.beginning_of_month..Date.today)
      completed = month_scores.where(:completed => 't')
      not_completed = month_scores.where(:completed => false)
      @completion = (completed.size/not_completed.size.to_f)*100

      # average time to take scorecard


      # evaluation progress per user





    end

  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user]
  end
end
