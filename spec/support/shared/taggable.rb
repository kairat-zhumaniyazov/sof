shared_examples_for 'taggable' do
  let(:model) { described_class }

  let!(:taggable) { create(model.to_s.underscore.to_sym, body: 'This is body with #first_tag and #secondtag') }

  context 'on create' do
    it 'taggable should have 2 tags' do
      expect(taggable.tags.count).to eq 2
    end

    it 'should have right tags' do
      expect(taggable.tags.first).to eq 'first_tag'
      expect(taggable.tags.last).to eq 'secondtag'
    end
  end

  context 'on update' do
    before do
      taggable.body = 'This is updated body with #another_tag, #newtag and #123withdigit'
      taggable.save
    end

    it 'should have 3 tags' do
      expect(taggable.tags.count).to eq 3
    end

    it 'should have right tags' do
      expect(taggable.tags.first).to eq 'another_tag'
      expect(taggable.tags.second).to eq 'newtag'
      expect(taggable.tags.last).to eq '123withdigit'
    end
  end

  context 'tags uniq' do
    before do
      taggable.body = 'This is updated body with #tag_1, #tag_1 and #tag_2 and #tag_2'
      taggable.save
    end

    it 'should have 2 tags' do
      expect(taggable.tags.count).to eq 2
    end

    it 'does have right tags' do
      expect(taggable.tags.first).to eq 'tag_1'
      expect(taggable.tags.last).to eq 'tag_2'
    end
  end
end
