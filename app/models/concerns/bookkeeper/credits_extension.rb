module Bookkeeper
  module CreditsExtension
    extend ActiveSupport::Concern

    included do
      self.normal_credit_balance = true
    end

    def self.balance(options = {})
      super(options)
    end

    def balance(options = {})
      super(options)
    end
  end
end
