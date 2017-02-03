require 'spec_helper'

module Bookkeeper
  RSpec.describe Account, type: :model do
    let(:account) { FactoryGirl.build(:account) }
    subject { account }

    it { expect be_valid } # must construct a child type instead

    describe 'when using a child type' do
      let(:account) { FactoryGirl.create(:account, type: 'Finance::Asset') }
      it { expect be_valid }

      it 'expect to be unique per name' do
        conflict = FactoryGirl.build(:account, name: account.name, type: account.type)
        expect(conflict).not_to be_valid
        expect(conflict.errors[:name]).eql? ['has already been taken']
      end
    end

    it 'expect calling the instance method #balance raise a NoMethodError' do
      expect { subject.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    it 'expect calling the class method ::balance to raise a NoMethodError' do
      expect { subject.class.balance }.to raise_error NoMethodError, "undefined method 'balance'"
    end

    describe '.trial_balance' do
      subject { Account.trial_balance }

      it { expect be_kind_of BigDecimal }

      context 'when given no entries' do
        it { should == 0 }
      end

      context 'when given correct entries' do
        before do
          # credit accounts
          liability = FactoryGirl.create(:liability)
          equity = FactoryGirl.create(:equity)
          revenue = FactoryGirl.create(:revenue)
          contra_asset = FactoryGirl.create(:asset, contra: true)
          contra_expense = FactoryGirl.create(:expense, contra: true)

          # debit accounts
          asset = FactoryGirl.create(:asset)
          expense = FactoryGirl.create(:expense)
          contra_liability = FactoryGirl.create(:liability, contra: true)
          contra_equity = FactoryGirl.create(:equity, contra: true)
          contra_revenue = FactoryGirl.create(:revenue, contra: true)

          # credit amounts
          # ca1 = FactoryGirl.build(:amount, :credit, account: liability, value: 100_000)
          # ca2 = FactoryGirl.build(:amount, :credit, account: equity, value: 1000)
          # ca3 = FactoryGirl.build(:amount, :credit, account: revenue, value: 40_404)
          # ca4 = FactoryGirl.build(:amount, :credit, account: contra_asset, value: 2)
          # ca5 = FactoryGirl.build(:amount, :credit, account: contra_expense, value: 333)

          # debit amounts
          # da1 = FactoryGirl.build(:amount, :debit, account: asset, value: 100_000)
          # da2 = FactoryGirl.build(:amount, :debit, account: expense, value: 1000)
          # da3 = FactoryGirl.build(:amount, :debit, account: contra_liability, value: 40_404)
          # da4 = FactoryGirl.build(:amount, :debit, account: contra_equity, value: 2)
          # da5 = FactoryGirl.build(:amount, :debit, account: contra_revenue, value: 333)

          # FactoryGirl.create(:entry, credit_amounts: [ca1], debit_amounts: [da1])
          # FactoryGirl.create(:entry, credit_amounts: [ca2], debit_amounts: [da2])
          # FactoryGirl.create(:entry, credit_amounts: [ca3], debit_amounts: [da3])
          # FactoryGirl.create(:entry, credit_amounts: [ca4], debit_amounts: [da4])
          # FactoryGirl.create(:entry, credit_amounts: [ca5], debit_amounts: [da5])

          entry1 = Entry.new(description: 'Description1', date: Date.today,
                             credits: [{ account_name: liability.name, value: 100_000 }],
                             debits: [{ account_name: asset.name, value: 100_000 }])
          entry1.save
          expect(entry1).to be_valid

          entry2 = Entry.new(description: 'Description1', date: Date.today,
                             credits: [{ account_name: equity.name, value: 1000 }],
                             debits: [{ account_name: expense.name, value: 1000 }])
          entry2.save
          expect(entry2).to be_valid

          entry3 = Entry.new(description: 'Description1', date: Date.today,
                             credits: [{ account_name: revenue.name, value: 40_404 }],
                             debits: [{ account_name: contra_liability.name, value: 40_404 }])
          entry3.save
          expect(entry3).to be_valid

          entry4 = Entry.new(description: 'Description1', date: Date.today,
                             credits: [{ account_name: contra_asset.name, value: 2 }],
                             debits: [{ account_name: contra_equity.name, value: 2 }])
          entry4.save
          expect(entry4).to be_valid

          entry5 = Entry.new(description: 'Description1', date: Date.today,
                             credits: [{ account_name: contra_expense.name, value: 2 }],
                             debits: [{ account_name: contra_revenue.name, value: 2 }])
          entry5.save
          expect(entry5).to be_valid
        end

        it { should == 0 }
      end
    end

    describe '#amounts' do
      it 'returns all credit and debit amounts' do
        equity = FactoryGirl.create(:equity)
        asset = FactoryGirl.create(:asset)
        expense = FactoryGirl.create(:expense)

        investment = Entry.new(
          description: 'Initial investment',
          date: Date.today,
          debits: [{ account_name: equity.name, value: 1000 }],
          credits: [{ account_name: asset.name, value: 1000 }]
        )
        investment.save

        purchase = Entry.new(
          description: 'First computer',
          date: Date.today,
          debits: [{ account_name: asset.name, value: 900 }],
          credits: [{ account_name: expense.name, value: 900 }]
        )
        purchase.save

        expect(equity.amounts.size).to eq 1
        expect(asset.amounts.size).to eq 2
        expect(expense.amounts.size).to eq 1
      end
    end

    describe '#entries' do
      it 'returns all credit and debit entries' do
        equity = FactoryGirl.create(:equity)
        asset = FactoryGirl.create(:asset)
        expense = FactoryGirl.create(:expense)

        investment = Entry.new(
          description: 'Initial investment',
          date: Date.today,
          debits: [{ account_name: equity.name, value: 1000 }],
          credits: [{ account_name: asset.name, value: 1000 }]
        )
        investment.save

        purchase = Entry.new(
          description: 'First computer',
          date: Date.today,
          debits: [{ account_name: asset.name, value: 900 }],
          credits: [{ account_name: expense.name, value: 900 }]
        )
        purchase.save

        expect(equity.entries.size).to eq 1
        expect(asset.entries.size).to eq 2
        expect(expense.entries.size).to eq 1
      end
    end
  end
end
