class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  check_authorization

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
