class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show

    trainee = @user.meta
    @last_assignment = trainee.get_nth_assignment(-1)
    @second_to_last_assignment = trainee.get_nth_assignment(-2)
    @observers = Project.find(@last_assignment.project_id).observers
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user]
  end
end
