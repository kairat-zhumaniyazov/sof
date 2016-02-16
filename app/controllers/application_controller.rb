require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:nickname, :email, :password, :password_confirmation,
               :remember_me, :avatar, :avatar_cache)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:nickname, :email, :password, :password_confirmation,
               :current_password, :avatar, :avatar_cache)
    end
  end
end
