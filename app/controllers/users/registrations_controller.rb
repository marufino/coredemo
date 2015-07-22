class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  # GET /users/sign_up
  def new

    # Override Devise default behaviour and create a profile as well
    build_resource({})
    resource.roles.build
    respond_with self.resource
  end

  private

  def user_params
    params[:user].permit!
  end

=begin
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u|
      u.permit(:email, :password, :password_confirmation, roles_attributes: [:id,:name])
    }
  end
=end

end