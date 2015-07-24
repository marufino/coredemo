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
    @project.assignments.build
    respond_with(@project)
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    #assign current user (observer) to this project
    @obs = current_user
    @project.observers << @obs.meta

    @project.save
    respond_with(@project)
  end

  def update
    @project.update(project_params)
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
      params[:project].permit(assignments_attributes: [:id, :date, :survey_id])
    end
end
