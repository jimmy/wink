require 'rubygems'
require 'expectations'
require 'wink/version'

Expectations do

  expect '0.3' do
    Wink::VERSION
  end

end
