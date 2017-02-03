module Bookkeeper
  class Revenue < Account
    include Bookkeeper::CreditsExtension
  end
end
