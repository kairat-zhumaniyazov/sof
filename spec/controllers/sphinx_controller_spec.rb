require 'rails_helper'

RSpec.describe SphinxController, type: :controller do
  describe 'GET #search' do
    [nil, 'question', 'answer', 'comment', 'user'].each do |index|
      it "with index: #{index} should receive to right indexed object" do
        obj = index ? Kernel.const_get(index.capitalize) : ThinkingSphinx
        expect(obj).to receive(:search).with(kind_of(String))
        get :search, search_query: { q: 'search query', index: index }
      end
    end
  end
end
