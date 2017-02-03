module Bookkeeper
  class Equity < Account
    include Bookkeeper::CreditsExtension
  end
end
