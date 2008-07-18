require 'help'

describe 'Wink::Schema' do

  before(:each) {
    setup_database
    @schema = Wink::Schema
  }

  it 'responds to ::configure and ::reset!' do
    @schema.should.respond_to :configure
    @schema.should.respond_to :reset!
  end

  it 'creates a welcome entry ...' do
    @schema.should.respond_to :create_welcome_entry!
    @schema.create_welcome_entry!
    entry = Entry.first(:slug => 'welcome')
    entry.should.not.be.nil
    @schema.create_welcome_entry!
  end

  it 'removes a welcome entry ...' do
    @schema.should.respond_to :remove_welcome_entry!
    @schema.create_welcome_entry!
    @schema.remove_welcome_entry!
    entry = Entry.first(:slug => 'welcome')
    entry.should.be.nil
  end

end


describe 'Database (DEPRECATED)' do

  it 'is defined' do
    Object.const_defined?(:Database).should.be.truthful
  end

  it 'responds to ::configure and ::reset!' do
    Database.should.respond_to :configure
    Database.should.respond_to :reset!
  end

end
