require 'spec_helper'

module Bookkeeper
  describe CreditAmount do
    it_behaves_like 'a Bookkeeper::Amount subtype', type: :credit_amount
  end
end
