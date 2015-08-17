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
      @observers = Project.find(@last_assignment.project_id).observers

      #@percent_improvement = compute_percent_improvement(@last_assignment, @second_to_last_assignment, @trainee)

      @graph = graph_scores_for_trainee(@trainee)

    elsif @user.observer? & !@user.role?('admin')
      # get next scorecard to be completed by this observer
      scores = get_scores_by_observer(@user.meta)

      # date for survey/profile card
      @score = scores.first
      @trainee = @score.trainee
      @last_assignment = @trainee.get_nth_assignment(-1)
      @second_to_last_assignment = @trainee.get_nth_assignment(-2)
      @observers = Project.find(@last_assignment.project_id).observers

      # get all trainees under this observer
      @trainees = get_trainees_by_observer(@user.meta)

      # generate graph
      @graph = graph_scores_for_trainee(@trainee)
    end



  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user]
  end
end
