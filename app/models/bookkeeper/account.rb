module Bookkeeper
  class Account < ActiveRecord::Base
    class_attribute :normal_credit_balance

    has_many :amounts
    has_many :credit_amounts, extend: AmountsExtension, inverse_of: :account
    has_many :debit_amounts, extend: AmountsExtension, inverse_of: :account

    has_many :entries, through: :amounts, source: :entry
    has_many :credit_entries, through: :credit_amounts, source: :entry
    has_many :debit_entries, through: :debit_amounts, source: :entry

    validates_presence_of :name, :type
    validates :name, uniqueness: { scope: [:type] }
    validates :code, uniqueness: { scope: [:type, :name] }

    def self.balance(options = {})
      raise(NoMethodError, "undefined method 'balance'") if new.class == Bookkeeper::Account
      accounts_balance = BigDecimal.new('0')
      accounts = all
      accounts.each do |account|
        next unless account.balance(options).present?
        accounts_balance -= account.balance(options) if account.contra?
        accounts_balance += account.balance(options) unless account.contra?
      end
      accounts_balance
    end

    def balance(options = {})
      raise(NoMethodError, "undefined method 'balance'") if self.class == Bookkeeper::Account
      return credits_balance(options) - debits_balance(options) if normal_credit_balance? ^ contra?
      debits_balance(options) - credits_balance(options)
    end

    def credits_balance(options = {})
      credit_amounts.balance(options)
    end

    def debits_balance(options = {})
      debit_amounts.balance(options)
    end

    def self.trial_balance
      raise(NoMethodError, "undefined method 'trial_balance'") unless new.class == Bookkeeper::Account
      assets = Bookkeeper::Asset.balance
      liabilities = Bookkeeper::Liability.balance
      equities = Bookkeeper::Equity.balance
      revenues = Bookkeeper::Revenue.balance
      expenses = Bookkeeper::Expense.balance
      assets - (liabilities + equities + revenues - expenses) # Assets = Liabilities + Expenses
    end

    def contra?
      contra
    end
  end
end
