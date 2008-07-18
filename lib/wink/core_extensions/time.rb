require 'date'
require 'time'

class Time
  def to_datetime
    DateTime.civil(year, mon, day, hour, min, sec)
  end
end
