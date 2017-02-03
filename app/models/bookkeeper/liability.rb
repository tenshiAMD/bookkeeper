module Bookkeeper
  class Liability < Account
    include Bookkeeper::CreditsExtension
  end
end
