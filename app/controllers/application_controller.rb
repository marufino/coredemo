class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  respond_to :js, :html

  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # my custom fields are :name, :heard_how
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles_attributes: [:id, :name] },:first_name,:last_name, :title, :email, :password, :password_confirmation, :meta_type) }

      devise_parameter_sanitizer.for(:account_update) { |u| u.permit({ roles_attributes: [:id, :name] },:first_name,:last_name, :title, :email, :password, :password_confirmation, :current_password, :meta_type) }
    end


  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end


end
