shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  before do
    @voted_to = create(model.to_s.underscore.to_sym)
  end

  it 'has a #vote_sum' do
    expect(@voted_to.votes_sum).to eq 0
  end

  describe 'has a #user_is_voted?' do
    context 'when user is voted before' do
      it 'does return true' do
        vote = create(:vote, voteable: @voted_to, user: user, value: 1)
        expect(@voted_to.user_is_voted? user).to be true
      end

      it 'does return false' do
        expect(@voted_to.user_is_voted? user).to be false
      end
    end
  end

  describe 'has a #re_vote' do
    it 'does destroy vote for Voteable' do
      vote = create(:vote, voteable: @voted_to, user: user, value: 1)
      @voted_to.re_vote user
      expect(@voted_to.user_is_voted? user).to be false
    end
  end


  describe 'has a #make_vote' do
    subject { @voted_to.make_vote(1, user) }

    context 'for new vote' do
      it 'should created new vote' do
        expect{ subject }.to change(@voted_to.votes, :count).by(1)
      end

      it 'should have right votes sum' do
        subject
        @voted_to.reload
        expect(@voted_to.votes_sum).to eq 1
      end

      it 'should call votes calculator' do
        expect(VotesCalculator).to receive(:calculate_for).with(@voted_to, 1)
        subject
      end
    end

    context 'for exists vote' do
      context 'Minus' do
        let!(:vote) { create(:vote, voteable: @voted_to, user: user, value: 1) }
        subject { @voted_to.make_vote(-1, user) }

        it 'should not create new vote' do
          expect { subject }.to_not change(Vote, :count)
        end

        it 'should have right votes sum' do
          subject
          @voted_to.reload
          expect(@voted_to.votes_sum).to eq -1
        end

        it 'should call votes calculator' do
          expect(VotesCalculator).to receive(:calculate_for).with(@voted_to, -2)
          subject
        end
      end

      context 'Plus' do
        let!(:vote) { create(:vote, voteable: @voted_to, user: user, value: -1) }
        subject { @voted_to.make_vote(1, user) }

        it 'should not create new vote' do
          expect { subject }.to_not change(Vote, :count)
        end

        it 'should have right votes sum' do
          subject
          @voted_to.reload
          expect(@voted_to.votes_sum).to eq 1
        end

        it 'should call votes calculator' do
          expect(VotesCalculator).to receive(:calculate_for).with(@voted_to, 2)
          subject
        end
      end
    end
  end
end
