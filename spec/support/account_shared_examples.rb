RSpec.shared_examples 'a Bookkeeper::Account subtype' do |params|
  let(:contra) { false }
  let(:account) { FactoryGirl.create(params[:type], contra: contra) }

  subject { account }

  describe 'class methods' do
    subject { account }

    its(:balance) { should be_kind_of(BigDecimal) }

    describe 'trial_balance' do
      it 'should raise NoMethodError' do
        -> { subject.trial_balance }.should raise_error NoMethodError
      end
    end
  end

  describe 'instance methods' do
    its(:balance) { should be_kind_of(BigDecimal) }

    it 'reports a balance with date range' do
      account.balance(from_date: '2014-01-01', to_date: Date.today).should be_kind_of(BigDecimal)
    end

    it { should respond_to(:credit_entries) }
    it { should respond_to(:debit_entries) }
  end

  it 'requires a name' do
    account.name = nil
    account.should_not be_valid
  end

  # Figure out which way credits and debits should apply
  if params[:normal_balance] == :debit
    credit_condition = :<
    debit_condition = :>
  else
    credit_condition = :>
    debit_condition = :<
  end

  describe 'when given a debit' do
    before { FactoryGirl.create(:debit_amount, account: account) }

    its(:balance) { should be.send(debit_condition, 0) }

    describe 'on a contra account' do
      let(:contra) { true }

      its(:balance) { should be.send(credit_condition, 0) }
    end
  end

  describe 'when given a credit' do
    before { FactoryGirl.create(:credit_amount, account: account) }

    its(:balance) { should be.send(credit_condition, 0) }

    describe 'on a contra account' do
      let(:contra) { true }

      its(:balance) { should be.send(debit_condition, 0) }
    end
  end
end
