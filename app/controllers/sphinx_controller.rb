class SphinxController < ApplicationController
  before_action :query_processing, only: :search

  def search
    authorize! :read, @results
    respond_with @results
  end

  private

  def query_processing
    param_index = search_params[:index]
    if SearchQuery::INDICES.include?(param_index)
      send("search_#{param_index}".to_sym,
           search_params[:q], param_index.capitalize.safe_constantize)
    else
      send(:search_everywhere, search_params[:q])
    end
  end

  def search_params
    params.require(:search_query).permit(:q, :index)
  end

  def search_everywhere(query)
    @results = ThinkingSphinx.search(query)
  end

  def search_model(query, klass = nil)
    @results = klass.search(query) if klass
  end

  alias_method :search_question, :search_model
  alias_method :search_answer, :search_model
  alias_method :search_comment, :search_model
  alias_method :search_user, :search_model
end
