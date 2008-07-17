require 'wink/core_extensions/date_time'

describe 'DateTime' do

  it 'responds to #iso8601' do
    datetime = DateTime.parse('1979-01-01T12:00:00-00:00')
    datetime.should.respond_to :iso8601
    datetime.iso8601.should.be == '1979-01-01T12:00:00+00:00'
  end

  it 'uses a more sane implementation of #inspect' do
    datetime = DateTime.parse('1979-01-01T12:00:00+05:00')
    datetime.inspect.should.equal '#<DateTime: 1979-01-01T12:00:00+05:00>'
  end

end
