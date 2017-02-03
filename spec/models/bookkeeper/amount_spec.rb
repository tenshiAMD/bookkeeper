require 'spec_helper'

module Bookkeeper
  RSpec.describe Amount, type: :model do
    subject { FactoryGirl.build(:amount) }

    it { should_not be_valid } # construct a child class instead
  end
end
