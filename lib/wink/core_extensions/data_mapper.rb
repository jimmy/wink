# datamapper-0.2.5 is incompatible with do_mysql-0.9.2
gem 'do_mysql', '=0.2.4'
require 'do_mysql'

gem 'datamapper', '=0.2.5'
require 'data_mapper'

class DataMapper::Database #:nodoc:

  class Logger < ::Logger
    def format_message(sev, date, message, progname)
      message = progname if message.blank?
      "#{message}\n"
    end
  end

end
