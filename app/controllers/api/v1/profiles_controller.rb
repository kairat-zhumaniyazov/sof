class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource User, user: @current_resource_owner

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with profiles: User.where.not(id: current_resource_owner)
  end
end
