require 'rubygems'
require 'expectations'
require 'wink'

Expectations do

  # tests that [] is an alias of attribute_get
  expect DataMapper::Resource.instance_method(:attribute_get) do
    DataMapper::Resource.instance_method(:[])
  end 
    
  # tests that []= is an alias of attribute_set
  expect DataMapper::Resource.instance_method(:attribute_set) do
    DataMapper::Resource.instance_method(:[]=)
  end

end
