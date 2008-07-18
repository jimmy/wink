require 'date'
require 'time'

class DateTime #:nodoc:
  # ISO 8601 formatted time value. This is 
  alias_method :iso8601, :to_s

  def inspect
    "#<DateTime: #{to_s}>"
  end
end

# http://www.rubyweeklynews.org/20051120
class DateTime
  # TODO: make sure we need this method
  def to_time
    Time.mktime(year, mon, day, hour, min, sec)
  end

  def to_date
    Date.new(year, mon, day)
  end
end
