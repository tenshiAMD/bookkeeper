module Bookkeeper
  module DebitsExtension
    extend ActiveSupport::Concern

    included do
      self.normal_credit_balance = false
    end

    def self.balance(options = {})
      super(options)
    end

    def balance(options = {})
      super(options)
    end
  end
end
