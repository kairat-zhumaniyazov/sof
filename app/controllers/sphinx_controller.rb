class SphinxController < ApplicationController
  before_action :indexed_class, only: :search

  def search
    authorize! :read, @results
    respond_with @results = @index.search(search_params[:q])
  end

  private

  # rubocop:disable Metrics/LineLength
  def indexed_class
    param_index = search_params[:index]
    @index =
      SearchQuery::INDICES.include?(param_index) ? param_index.capitalize.safe_constantize : ThinkingSphinx
  end

  def search_params
    params.require(:search_query).permit(:q, :index)
  end
end
