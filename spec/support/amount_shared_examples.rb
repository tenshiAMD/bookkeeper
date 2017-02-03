RSpec.shared_examples 'a Bookkeeper::Amount subtype' do |params|
  let(:amount) { FactoryGirl.build(params[:type]) }

  subject { amount }

  it { should be_valid }

  it 'should require an amount' do
    amount.value = nil
    amount.should_not be_valid
  end

  it 'should require a entry' do
    amount.entry = nil
    amount.should_not be_valid
  end

  it 'should require an account' do
    amount.account = nil
    amount.should_not be_valid
  end
end
