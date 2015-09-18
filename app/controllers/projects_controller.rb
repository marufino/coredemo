class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @projects = Project.all
    respond_with(@projects)
  end

  def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    @assignments = @project.assignments.build

    @colors = []
    3.times do
      @colors << @project.colors.build
    end

    respond_with(@project)
  end

  def edit
    @colors = @project.colors
  end

  def create

    @project = Project.new(project_params)

    # assign observers to this project
    @obs_ids = params[:project][:observer_ids]
    @obs_ids.reject!(&:empty?)
    @obs = Observer.find(@obs_ids)
    @project.observers = @obs

    @project.colors.each_with_index do |c,i|
      c.color = $colors[i]
      c.save
    end

    # for every assignment
    @project.assignments.each_with_index { | assignment , i |

      # add trainees to assignments
      @trainee_ids = params[:project][:assignments_attributes].values[i][:trainee_ids]
      @trainee_ids.reject!(&:empty?)
      @trainees = Trainee.find(@trainee_ids)
      assignment.trainees = @trainees

      # assign survey to project
      @survey = Survey.find(params[:project][:assignments_attributes].values[i][:survey_id])
      assignment.surveys = []
      assignment.surveys << @survey

      # for every trainee create a score object
      @trainees.each_with_index { |trainee, i |

        @score = Score.new()
        @score.trainee = trainee
        @score.assignment = assignment
        @score.assigned_date = assignment.date
        @score.completed = false
        @score.build_area_of_weakness
        @score.build_area_of_strength

        # build ratings for every question
        @survey.questions.each do |q|
          rating = @score.ratings.build
          rating.question = q
          q.rating = rating
        end

        @survey.save
        @score.save
      }
    }

    @project.save
    respond_with(@project)
  end

  def update
    @project.update(project_params)

    # assign current user (observer) to this project
    @obs_ids = params[:project][:observer_ids]
    @obs_ids.reject!(&:empty?)
    @obs = Observer.find(@obs_ids)
    @project.observers = @obs

    @project.colors.each_with_index do |c,i|
      c.color = $colors[i]
      c.save
    end

    # for every assignment
    @project.assignments.each_with_index { | assignment , i |

      # add trainees to assignments
      @trainee_ids = params[:project][:assignments_attributes].values[i][:trainee_ids]
      @trainee_ids.reject!(&:empty?)
      @trainees = Trainee.find(@trainee_ids)
      assignment.trainees = @trainees

      # assign survey to project
      @survey = Survey.find(params[:project][:assignments_attributes].values[i][:survey_id])
      assignment.surveys = []
      assignment.surveys << @survey

      # for every trainee create a score object
      @trainees.each_with_index { |trainee, i |

        @score = Score.new()
        @score.trainee = trainee
        @score.assignment = assignment
        @score.assigned_date = assignment.date

        # build ratings for every question
        @survey.questions.each do |q|
          rating = @score.ratings.build
          rating.question = q
          q.rating = rating
        end

        @survey.save
        @score.save
      }
    }

    respond_with(@project)
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
      params[:project].permit(:name, :observer_ids, assignments_attributes: [:id, :date, :survey_id, :trainee_ids], colors_attributes: [:id, :value])
    end
end
