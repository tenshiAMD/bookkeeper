module Bookkeeper
  class Amount < ActiveRecord::Base
    belongs_to :account
    belongs_to :entry

    validates_presence_of :type, :account, :entry, :value

    def account_name=(name)
      self.account = Account.find_by_name(name)
    end
  end
end
