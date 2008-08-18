module Wink
  module Schema
    extend self

    def reset!
      DataMapper.setup(:default, 'sqlite3::memory:')
      DataMapper.auto_migrate!
    end
  end
end
