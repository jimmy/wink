require 'help'

describe 'wink/delicious' do

  it 'can be required (no syntax errors)' do
    require 'wink/delicious'
  end

end

describe 'Wink::Delicious' do

  before { require 'wink/delicious' }

  def cache(username='test', password='test')
    Wink::Delicious.new username, password,
      :cache => "#{File.dirname(__FILE__)}/delicious_bookmarks.xml"
  end

  it 'should support synchronizing from cache file' do
    delicious = cache('test_user', 'test_password')
    delicious.user.should.be == 'test_user'
    delicious.password.should.be == 'test_password'
    delicious.cache.should.not.be.nil
  end

  it 'should respond to #last_updated_at from cache' do
    cache.last_updated_at.should.be == Time.iso8601('2008-06-24T05:24:15Z')
  end

  it 'should give last_updated_at in utc' do
    cache.last_updated_at.should.be.utc
  end

  it 'should yield bookmarks with block to #synchronize' do
    count = 0
    cache.synchronize do |bookmark|
      [ :shared, :tags, :description, :extended, :time, :href, :hash ].each do |key|
        assert_not_nil bookmark[key], "#{key.inspect} should be set"
        assert bookmark[:tags].length > 0, "should be some tags"
      end
      count += 1
    end
    count.should.be == 5
  end

  it 'should respond with enumerator with no block to #synchronize' do
    enumerable = cache.synchronize
    enumerable.should.respond_to :each
    enumerable.should.respond_to :to_a
  end

  it 'should synchronize all bookmarks with no :since option' do
    enumerable = cache.synchronize
    enumerable.to_a.length.should.be 5
  end

  it 'should synchronize only new bookmarks with :since option' do
    updated = Time.iso8601('2008-06-23T20:34:23Z')
    cache.synchronize(:since => updated).to_a.length.should.be == 2
  end

  it 'should not synchronize anything when updated is later than most recent' do
    updated = Time.iso8601('2010-06-23T20:34:23Z')
    cache.synchronize :since => updated do |bookmark|
      flunk "#synchronize should not yield with since in the future"
    end
  end

end
