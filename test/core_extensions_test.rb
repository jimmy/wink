require 'help'

describe 'Time' do

  it 'responds to #to_datetime' do
    time = Time.iso8601('1979-01-01T12:00:00Z')
    time.iso8601.should.equal '1979-01-01T12:00:00Z'
    time.should.respond_to :to_datetime
    time.to_datetime.should.be == DateTime.parse('1979-01-01T12:00:00Z')
  end

  it 'preserves timezone information when converting to DateTime' do
    time = Time.parse('Mon Jan 01 12:10:23 PST 1979').utc
    time.iso8601.should.equal '1979-01-01T20:10:23Z'
    time.utc_offset.should.be == 0
    time.to_datetime.should.be == DateTime.parse('1979-01-01T15:10:23-05:00')
  end

end
