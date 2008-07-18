require 'lib/wink/core_extensions/data_mapper'
require 'mocha'

# TODO: If the Logger feature is ported, then active these
#describe 'DataMapper' do
#
#  it 'should log message when message is a string' do
#     logger = DataMapper::Database::Logger.new(nil)
#     message = 'hello world'
#     progname = 'wink'
#     logger.format_message(stub_everything, stub_everything,
#       message, progname).should == "hello world\n"
#  end
#
#  it 'should log message when message is a blank' do
#     logger = DataMapper::Database::Logger.new(nil)
#     message = stub_everything(:blank? => true)
#     progname = 'wink'
#     logger.format_message(stub_everything, stub_everything,
#       message, progname).should == "wink\n"
#  end
#
#  it 'should log progname when message is the empty string' do
#     logger = DataMapper::Database::Logger.new(nil)
#     message = ''
#     progname = 'wink'
#     logger.format_message(stub_everything, stub_everything,
#       message, progname).should == "wink\n"
#  end
#
#  it 'should log progname when message is nil' do
#     logger = DataMapper::Database::Logger.new(nil)
#     message = nil
#     progname = 'wink'
#     logger.format_message(stub_everything, stub_everything,
#       message, progname).should == "wink\n"
#  end
#
#end
