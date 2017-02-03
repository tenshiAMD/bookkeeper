module Bookkeeper
  class Asset < Account
    include Bookkeeper::DebitsExtension
  end
end
