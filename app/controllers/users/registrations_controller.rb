class Users::RegistrationsController < Devise::RegistrationsController

  skip_before_filter :require_no_authentication


  # GET /users/sign_up
  def new
    # Override Devise default behaviour and create a profile as well
    @user = User.new
  end

  def create

    user_type = params[:user][:meta_type]

    @user = User.create(sign_up_params)

    respond_to do |format|

      if @user.save

        # if observer, create an observer, assign it the user params
        if user_type.casecmp('Observer') == 0
          @observer = Observer.create()
          @observer.user = @user
          @observer.save
          # if trainee, create a trainee
        elsif user_type.casecmp('Trainee') == 0
          @trainee = Trainee.create()
          @trainee.user = @user
          @trainee.save
        end

        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, alert: @user.errors  }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end


end