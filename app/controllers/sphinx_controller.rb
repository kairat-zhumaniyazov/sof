class SphinxController < ApplicationController
  #authorize_resource SphinxController

  def search
    authorize! :read, @results
    respond_with @results = ThinkingSphinx.search(search_params[:q])
  end

  private

  def search_params
    params.require(:search_query).permit(:q)
  end
end
