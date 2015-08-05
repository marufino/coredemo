class UsersController < ApplicationController
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
    trainee = @user.meta
    @last_assignment = trainee.get_nth_assignment(-1)
    @second_to_last_assignment = trainee.get_nth_assignment(-2)
    @observers = Project.find(@last_assignment.project_id).observers

    totals = []
    dates = []
    # scores for current user
    scores = Score.where( :trainee_id => @user.meta.id)
    # parse out totals
    scores.each { |s| totals << s.total}
    # parse out dates
    scores.each { |s| dates << s.assignment.date}
    @graph = dates.zip totals

  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user]
  end
end
