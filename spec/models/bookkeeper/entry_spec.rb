require 'spec_helper'

module Bookkeeper
  RSpec.describe Entry, type: :model do
    let(:entry) { FactoryGirl.build(:entry) }
    let(:credit_account) { FactoryGirl.create(:revenue) }
    let(:debit_account) { FactoryGirl.create(:asset) }

    subject { entry }

    it { should_not be_valid }

    context 'with credit and debit' do
      let(:entry) { FactoryGirl.build(:entry, :with_credit_and_debit) }

      it { should be_valid }

      it 'should require a description' do
        entry.description = nil

        expect(entry).not_to be_valid
      end
    end

    context 'with a debit' do
      before do
        subject.debits = [{ account: debit_account, value: 100 }]
      end

      it { should_not be_valid }

      context 'with an invalid credit' do
        before do
          subject.credits = [{ account: credit_account, value: nil }]
        end

        it { should_not be_valid }
      end
    end

    context 'with a credit' do
      before do
        subject.credits = [{ account: credit_account, value: 100 }]
      end

      it { should_not be_valid }

      context 'with an invalid debit' do
        before do
          subject.debits = [{ account: debit_account, value: nil }]
        end

        it { should_not be_valid }
      end
    end

    context 'without a date' do
      let(:entry) { FactoryGirl.build(:entry, :with_credit_and_debit, date: nil) }

      it { should_not be_valid }
    end

    it 'should require the debit and credit amounts to cancel' do
      subject.credits = [{ account: credit_account, value: 200 }]
      subject.debits = [{ account: debit_account, value: 100 }]

      expect(subject).not_to be_valid
      expect(subject.errors['base']).eql?(['The credit and debit amounts must be equal.'])
    end

    it 'should require the debit and credit amounts to cancel even with fractions' do
      entry.credits = [{ account: credit_account, value: 100.1 }]
      entry.debits = [{ account: debit_account, value: 100.2 }]

      expect(subject).not_to be_valid
      expect(subject.errors['base']).eql?(['The credit and debit amounts must be equal.'])
    end

    it 'should ignore debit and credit amounts marked for destruction to cancel' do
      entry.credits = [{ account: credit_account, value: 100 }, { account: credit_account, value: 100 }]
      entry.debits = [{ account: debit_account, value: 100 }, { account: debit_account, value: 100, _destroy: true }]

      expect(subject).not_to be_valid
      expect(subject.errors['base']).eql?(['The credit and debit amounts must be equal.'])
    end
  end
end
