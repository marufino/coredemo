class UsersController < ApplicationController
  include ApplicationHelper
  respond_to :html, :json

  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show

    @curr_page_users = true

    @user = User.find(params[:id])

    if @user.trainee?

      @trainee = @user.meta

      @score = @user.meta.last_completed_scorecard

      if @score
        @percent_improvement = @score.percent_improvement(@trainee)
      end

      @graph = graph_scores_for_trainee(@trainee)

      @aos = @user.meta.get_aos
      @aow = @user.meta.get_aow


    elsif @user.observer? & !@user.role?('admin')
      # get next scorecard to be completed by this observer
      scores = get_scores_by_observer(@user.meta)

      # date for survey/profile card
      @score = scores.last

      if @score
        @trainee = @score.trainee

        # get all trainees under this observer
        @trainees = get_trainees_by_observer(@user.meta)

        @percent_improvement = @trainee.previous_scorecard(@score).percent_improvement(@trainee)

        # generate graph
        @graph = graph_scores_for_observer(@user.meta)
      end


    elsif @user.role?('admin')

      # get last N(10) completed scores
      @scores = Score.where(:completed => 't').order(completed_date: :desc).first(10)

      @users = []
      @last_assignments = []
      @second_to_last_assignments = []
      @percent_improvements = []
      @observers = Array.new() { Array.new()}

      # populate profile cards based on scores
      @scores.each do |s|
        @users.push(s.trainee.user)
      end

      @scores.each do |s|
        @percent_improvements.push(s.percent_improvement(s.trainee))
      end

      @users.each_with_index do |u,i|
        trainee = u.meta
        last_assignment = trainee.get_nth_assignment(-1)
        second_to_last_assignment = trainee.get_nth_assignment(-2)

        @last_assignments.push(last_assignment)
        @second_to_last_assignments.push(second_to_last_assignment)
      end

      # generate graph
      @graph = graph_scores_for_admin

      # VIZ 1
      ### scores completed this month
      month_scores = Score.where(assigned_date: Date.today.beginning_of_month..Date.today)
      if (!month_scores.empty?)
        completed = month_scores.where(:completed => 't')
        not_completed = month_scores.where(:completed => 'f')
        @completion = (completed.size/month_scores.size.to_f)*100
      end

      # VIZ 2
      ### average time to take scorecard
      # for all scores
      scores = Score.all

      # calculate diff of completed date vs assigned date
      @time_taken=[]
      scores.each do |s|
        if s.completed
          @time_taken.push((s.completed_date - s.assignment.date).to_i)
        end
      end
      # replace negatives with 0s
      @time_taken.map!{|val| if val<0 then 0 else val end}

      # group by tens of days
      @time_taken = @time_taken.group_by { |i| i/7 }

      # count occurences in each group of days
      @time_taken.keys.each { |i| @time_taken[i] = @time_taken[i].count }



      # VIZ 3
      ### evaluation progress per user
      trainees = Trainee.all

      @eval_progress = Hash.new
      # for each user
      trainees.each do |t|
        @eval_progress[t.user.full_name] = t.percent_scores_completed
      end
      @eval_keys = @eval_progress.keys.paginate(:page => params[:page],:per_page => 8)


      @top_performers = Hash.new
      # VIZ 4
      ### top performers
      trainees.each do |t|
        @top_performers[t.user.full_name] = t.get_core_score
      end

      @top_performers = @top_performers.sort_by{ |name, score| score}.last(9).reverse

    end

  end

  def import
    respond_to do |format|
      if User.import(params[:file])
        format.html { redirect_to users_path, notice: 'Users successfully imported.' }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { redirect_to users_path , alert: 'Wrong formatting. Could not import' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to users_path, notice: "User updated."
  end

  def destroy
    if @user.trainee?
      @user.meta.delete_all_scores
      Trainee.destroy(@user.meta_id)
    elsif @user.observer?
      # check if project becomes "orphan" and if so don't allow delete
      projects = @user.meta.projects

      projects.each do |p|
        if p.observers.size == 1
          redirect_to users_path, alert: "Can't delete Observer. Project:'" + p.name + "' would be left without observers. Please assign additional observers before deleting."
          return
        end
      end

      Observer.destroy(@user.meta_id)
    end

    @user.destroy
    redirect_to users_path, notice: "User deleted."
  end


  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user].permit(:first_name, :last_name, :email, :phone, :title, :meta_type)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
