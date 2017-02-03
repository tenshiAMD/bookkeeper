require 'spec_helper'

module Bookkeeper
  describe DebitAmount do
    it_behaves_like 'a Bookkeeper::Amount subtype', type: :debit_amount
  end
end
