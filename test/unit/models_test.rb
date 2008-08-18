require 'rubygems'
require 'expectations'
require 'wink'

Expectations do

  expect true do
    Wink::Models.reload!
  end

end

