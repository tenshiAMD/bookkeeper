require 'spec_helper'

module Bookkeeper
  RSpec.describe Liability, type: :model do
    it_behaves_like 'a Bookkeeper::Account subtype', type: :asset, normal_balance: :credit
  end
end
