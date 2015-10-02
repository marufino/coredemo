class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @projects = Project.all
    respond_with(@projects)
  end

  def show
    @assignments = @project.assignments
    @colors = @project.colors
    respond_with(@project)
  end

  def new
    @project = Project.new
    @assignments = []
    @assignments << @project.assignments.build

    @colors = []
    3.times do
      @colors << @project.colors.build
    end

  end

  def edit
    @colors = @project.colors
    @assignments = @project.assignments
  end

  def create

    @project = Project.new(project_params)

    @colors = @project.colors
    # assign observers to this project
    obs_ids = params[:project][:observer_ids]
    obs_ids.reject!(&:empty?)
    obs = Observer.find(obs_ids)
    @project.observers = obs

    @project.colors.each_with_index do |c,i|
      c.color = $colors[i]
    end

    scores_all = []

    # for every assignment
    @project.assignments.each_with_index { | assignment , i |

      # add trainees to assignments
      trainee_ids = params[:project][:assignments_attributes].values[i][:trainee_ids]
      trainee_ids.reject!(&:empty?)
      trainees = Trainee.find(trainee_ids)
      assignment.trainees = trainees

      # assign survey to project
      survey = Survey.find(params[:project][:assignments_attributes].values[i][:survey_id])
      assignment.surveys = []
      assignment.surveys << survey


      # for every trainee create a score object
      trainees.each_with_index { |trainee, i |

        score = Score.new()
        score.trainee = trainee
        score.assignment = assignment
        score.assigned_date = assignment.date
        score.completed = false
        score.build_area_of_weakness
        score.build_area_of_strength

        # build ratings for every question
        survey.questions.each do |q|
          rating = score.ratings.build
          rating.question = q
          q.rating = rating
        end

        scores_all << score

      }
    }

    respond_to do |format|
      if @project.save

        @project.colors.each do |c|
          c.save
        end

        @project.assignments.each do |a|
          a.save
        end

        scores_all.each do |s|
          s.save
        end

        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    @colors = @project.colors
    @assignments = @project.assignments

    @project.update(project_params)

    # assign current user (observer) to this project
    obs_ids = params[:project][:observer_ids]
    obs_ids.reject!(&:empty?)
    obs = Observer.find(obs_ids)
    @project.observers = obs

    @project.colors.each_with_index do |c,i|
      c.color = $colors[i]
      c.save
    end

    # for every assignment
    @project.assignments.each_with_index { | assignment , i |

      # add trainees to assignments
      trainee_ids = params[:project][:assignments_attributes].values[i][:trainee_ids]
      trainee_ids.reject!(&:empty?)
      trainees = Trainee.find(trainee_ids)
      assignment.update(:trainees => trainees)

      # assign survey to project
      survey = Survey.find(params[:project][:assignments_attributes].values[i][:survey_id])
      assignment.surveys = []
      assignment.surveys << survey


      # for every trainee create a score object
      trainees.each_with_index { |trainee, i |

        # if score exists update its date
        if score = Score.where(:trainee_id => trainee.id, :assignment_id => assignment.id).first
          score.update(:assigned_date => assignment.date)

          # if scorecard changed then scores must be re-done
          score.completed = false

          # delete all ratings from score
          score.delete_ratings
          score.clear_score

          # update ratings for every question
          survey.questions.each do |q|
            rating = score.ratings.build
            rating.question = q
            q.rating = rating
          end
        else

          # if score doesn't exist build it
          score = Score.new()
          score.trainee = trainee
          score.assignment = assignment
          score.assigned_date = assignment.date
          score.completed = false
          score.build_area_of_weakness
          score.build_area_of_strength

          # build ratings for every question
          survey.questions.each do |q|
            rating = score.ratings.build
            rating.question = q
            q.rating = rating
          end


        end

        survey.save
        score.save
      }
    }

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params[:project].permit(:name, :observer_ids, assignments_attributes: [:date, :survey_id, :trainee_ids, :_destroy], colors_attributes: [:value])
    end
end
