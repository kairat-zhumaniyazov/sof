shared_examples_for 'Publishable' do
  it 'should publish after creating' do
    expect(PrivatePub).to receive(:publish_to).with(channel, kind_of(Hash))
    subject
  end
end
