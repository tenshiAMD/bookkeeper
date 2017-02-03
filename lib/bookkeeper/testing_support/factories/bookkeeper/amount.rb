module Bookkeeper
  FactoryGirl.define do
    factory :amount, class: Amount do
      value { BigDecimal.new('123') }

      association :entry, factory: [:entry, :with_credit_and_debit]
      association :account, factory: :asset
    end

    AMOUNT_SUBTYPES = %w(credit_amount debit_amount).freeze
    AMOUNT_SUBTYPES.each do |subtype|
      factory subtype.to_sym, class: "Bookkeeper::#{subtype.classify}" do
        value { BigDecimal.new('123') }

        association :entry, factory: [:entry, :with_credit_and_debit]
        association :account, factory: :revenue if subtype == 'credit_amount'
        association :account, factory: :asset if subtype == 'debit_amount'
      end
    end
  end
end
