require 'rubygems'
require 'expectations'
require 'wink'

Expectations do

  expect DataMapper.to.receive(:setup) do
    DataMapper.stubs(:auto_migrate!)
    Wink::Schema.reset!
  end

  expect DataMapper.to.receive(:auto_migrate!) do
    DataMapper.stubs(:setup)
    Wink::Schema.reset!
  end

end
