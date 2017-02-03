module Bookkeeper
  FactoryGirl.define do
    factory :entry, class: Entry do
      description { 'factory description' }
      date { Time.zone.today }
    end

    trait :with_credit_and_debit do
      after(:build) do |entry|
        credit_account = create(:revenue)
        debit_account = create(:asset)
        entry.credits = [{ account_name: credit_account.name, value: BigDecimal.new('123') }]
        entry.debits = [{ account_name: debit_account.name, value: BigDecimal.new('123') }]

        # entry.credit_amounts << FactoryGirl.build(:amount, :credit, entry: entry)
        # entry.debit_amounts << FactoryGirl.build(:amount, :debit, entry: entry)
      end
    end
  end
end
