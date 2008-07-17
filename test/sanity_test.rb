require 'help'

describe 'String' do

  it 'responds to blank?' do
    [ '', nil, [], {} ].each do |o|
      o.should.respond_to :blank?
      o.blank?.should.be true
    end
    [ 0, ['hi'], { :a => 1 } ].each do |o|
      o.should.respond_to :blank?
      o.blank?.should.be false
    end
  end

end

describe 'Sinatra' do

  it 'should not have reloading enabled in test environment' do
    Wink.reloading?.should.not.be.truthful
  end

  it 'should not have automatic server running enabled' do
    Sinatra.application.options.run.should.not.be.truthful
  end

end
