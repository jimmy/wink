require 'dm-core'

module Wink
  module Schema
    extend self

    def reset!
      gem 'do_sqlite3', '=0.9.2'
      require 'do_sqlite3'

      DataMapper.setup(:default, 'sqlite3::memory:')
      DataMapper.auto_migrate!
    end
  end
end
