class Users::RegistrationsController < Devise::RegistrationsController

  # GET /users/sign_up
  def new
    # Override Devise default behaviour and create a profile as well
    build_resource({})
    resource.roles.build
    respond_with self.resource
  end


end