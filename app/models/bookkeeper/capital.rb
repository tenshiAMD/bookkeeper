module Bookkeeper
  class Capital < Account
    include Bookkeeper::CreditsExtension
  end
end
