require 'lib/wink/core_extensions/wink'
require 'mocha'

describe 'core_extensions/wink' do

  it 'should delegate Wink.environment to Sinatra.env' do
    Sinatra.stubs(:env).returns(:production)
    Wink.environment.should == :production
  end

  it 'should respond to production? correctly' do
    Sinatra.stubs(:env).returns(:production)
    Wink.should.be.production
  end

  it 'should respond to production? correctly' do
    Sinatra.stubs(:env).returns(:development)
    Wink.should.not.be.production
  end

  it 'should respond to development? correctly' do
    Sinatra.stubs(:env).returns(:development)
    Wink.should.be.development
  end

  it 'should respond to development? correctly' do
    Sinatra.stubs(:env).returns(:production)
    Wink.should.not.be.development
  end

  it 'should respond to reloading? by delegating to Sinatra' do
    Sinatra.stubs(:application).returns stub_everything(:reloading? => true)
    Wink.should.be.reloading
  end

  it 'should respond to reloading? by delegating to Sinatra' do
    Sinatra.stubs(:application).returns stub_everything(:reloading? => false)
    Wink.should.not.be.reloading
  end

end
