require 'help'

describe 'Date' do

  it 'uses a more sane implementation of #inspect' do
    datetime = Date.new(1979, 1, 1)
    datetime.inspect.should.equal '#<Date: 1979-01-01>'
  end

end
