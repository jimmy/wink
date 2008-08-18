require 'rubygems'
require 'expectations'
require 'wink'

Expectations do

  expect '0.3' do
    Wink::VERSION
  end

end
