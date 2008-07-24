require 'rubygems'
require 'expectations'
require 'wink/models'

Expectations do

  expect true do
    Wink::Models.reload!
  end

end

