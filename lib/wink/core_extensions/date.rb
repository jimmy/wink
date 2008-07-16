require 'date'
require 'time'

class Date #:nodoc:
  def inspect
    "#<Date: #{to_s}>"
  end
end
