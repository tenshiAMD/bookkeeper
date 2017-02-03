module Bookkeeper
  class Entry < ActiveRecord::Base
    has_many :credit_amounts, extend: AmountsExtension, inverse_of: :entry
    has_many :debit_amounts, extend: AmountsExtension, inverse_of: :entry
    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true
    alias credits= credit_amounts_attributes=
    alias debits= debit_amounts_attributes=

    has_many :credit_accounts, through: :credit_amounts, source: :account
    has_many :debit_accounts, through: :debit_amounts, source: :account

    validates_presence_of :description, :date, :credit_amounts, :debit_amounts

    validate :credit_cancels_debit

    private

    def credit_cancels_debit
      return if credit_amounts.balance_for_new_record == debit_amounts.balance_for_new_record
      errors[:base] << 'The credit and debit amounts must be equal.'
    end
  end
end
