class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :check_permissions, :only => [:new, :create, :cancel]
  skip_before_filter :require_no_authentication

  def check_permissions
    authorize! :create, resource
  end

  # GET /users/sign_up
  def new
    # Override Devise default behaviour and create a profile as well
    @user = User.new
    @user.roles.build

    #build_resource({})
    #resource.roles.build
    #respond_with self.resource
  end

  def create

    user_type = params[:user][:roles_attributes].values.first[:name]

    @user = User.create!(sign_up_params)

    # if observer, create an observer, assign it the user params
    if user_type == 'observer'
      @observer = Observer.create()
      @observer.user = @user
      @observer.save
    # if trainee, create a trainee
    elsif user_type =='trainee'
      @trainee = Trainee.create()
      @trainee.user = @user
      @trainee.save
    end


    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end


end