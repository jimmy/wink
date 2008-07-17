require 'wink/core_extensions/rack'

describe 'Rack::Request#remote_ip' do

  def rack_env
    { 'HTTP_X_FORWARDED_FOR' => '11.111.111.11',
      'HTTP_CLIENT_IP' => '22.222.222.22',
      'REMOTE_ADDR' => '33.333.333.33',
      'HTTP_HOST' => 'localhost:80' }
  end

  it 'responds to' do
    Rack::Request.new(rack_env).should.respond_to :remote_ip
  end

  it 'responds with X-Forwarded-For header when present' do
    request = Rack::Request.new(rack_env)
    request.remote_ip.should.equal '11.111.111.11'
  end

  it 'responds with Client-IP header when X-Forwarded-For not present' do
    environment = rack_env
    environment.delete('HTTP_X_FORWARDED_FOR')
    request = Rack::Request.new(environment)
    request.remote_ip.should.equal '22.222.222.22'
  end

  it 'responds with REMOTE_ADDR when X-Forwarded-For or Client-IP headers not present' do
    environment = rack_env
    environment.delete('HTTP_X_FORWARDED_FOR')
    environment.delete('HTTP_CLIENT_IP')
    request = Rack::Request.new(environment)
    request.remote_ip.should.equal '33.333.333.33'
  end

end
