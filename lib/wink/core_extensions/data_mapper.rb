gem 'dm-core', '=0.9.2'
require 'dm-core'

module DataMapper::Resource
  alias [] attribute_get
  alias []= attribute_set

  module ClassMethods
    def find_or_create(options)
      first(options.dup) || create(options.dup)
    end
  end
end

# TODO: This was used with datamapper-0.2.5.  Port if necessary.
#class DataMapper::Database #:nodoc:
#
#  class Logger < ::Logger
#    def format_message(sev, date, message, progname)
#      message_to_log = !message.blank? ? message : progname
#      "#{message_to_log}\n"
#    end
#  end
#
#end
