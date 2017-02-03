module Bookkeeper
  def self.config
    yield(self)
  end
end

require 'bookkeeper/migrations'
require 'bookkeeper/engine'
