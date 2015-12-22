require 'rails_helper'

RSpec.describe SphinxController, type: :controller do
  describe 'GET #search' do
    it 'should return questions' do
      expect(Question).to receive(:search).with(kind_of(String))
      get :search, search_query: { q: 'search query' }
    end
  end
end
