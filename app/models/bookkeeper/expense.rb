module Bookkeeper
  class Expense < Account
    include Bookkeeper::DebitsExtension
  end
end
