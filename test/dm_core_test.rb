# This displays a bug that causes some valid wink tests to fail.
# TODO: patch this as a core extension, or upgrade dm-core.
require 'dm-core'
DataMapper.setup(:default, "sqlite3::memory:")
class Pet
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :class_type, Discriminator
end
class Dog < Pet; end
context 'DataMapper.auto_migrate!' do
  it 'should work with STI' do
    DataMapper.auto_migrate!
    Dog.create!(:name => "first")
    Dog.first

    DataMapper.auto_migrate!
    Dog.first.should.be.nil
    dog = Dog.create!(:name => "second")
    dog.name.should == "second"
    Dog.first.name.should == "second"
  end
end
