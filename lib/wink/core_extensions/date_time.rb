require 'date'
require 'time'

class DateTime #:nodoc:
  # ISO 8601 formatted time value. This is 
  alias_method :iso8601, :to_s

  def inspect
    "#<DateTime: #{to_s}>"
  end
end
