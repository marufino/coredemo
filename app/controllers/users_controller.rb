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
        @graph = graph_scores_for_observer(@user.meta)
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
      @graph = graph_scores_for_admin

      # VIZ 1
      ### scores completed this month
      month_scores = Score.where(completed_date: Date.today.beginning_of_month..Date.today)
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
        @time_taken.push((s.completed_date - s.assignment.date).to_i)
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

      #@eval_keys = WillPaginate::Collection.create(1, 5, eval_keys.length) do |pager|
      #  pager.replace eval_keys
      #end

      @top_performers = Hash.new
      # VIZ 4
      ### top performers
      trainees.each do |t|
        @top_performers[t.user.full_name] = t.get_core_score
      end

      @top_performers = @top_performers.sort_by{ |name, score| score}.last(9).reverse

    end

  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user]
  end
end
