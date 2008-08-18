require 'rubygems'
require 'wink/version'

gem 'extlib',         '= 0.9.2'
gem 'dm-core',        '= 0.9.2'
gem 'dm-validations', '= 0.9.2'
gem 'dm-timestamps',  '= 0.9.2'
gem 'do_sqlite3',     '= 0.9.2'

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'do_sqlite3'

require 'wink/core_extensions'
require 'wink/models'
