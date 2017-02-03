module Bookkeeper
  FactoryGirl.define do
    factory :account, class: Account do
      sequence(:name) { |n| "Account_#{n}" }
      contra { false }
    end

    ACCOUNT_SUBTYPES = %w(asset equity capital expense liability revenue).freeze
    ACCOUNT_SUBTYPES.each do |subtype|
      factory subtype.to_sym, class: "Bookkeeper::#{subtype.classify}".constantize do
        sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
        contra { false }
      end
    end
  end
end
