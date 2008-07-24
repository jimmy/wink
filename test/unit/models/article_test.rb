require 'rubygems'
require 'expectations'
require 'wink/models/article'

Expectations do

  expect true do
    Article.new.is_a?(DataMapper::Resource)
  end

  expect Article.properties[:id].to.be.serial?

  expect Article.properties[:id].to.be.key?

  expect String do
    Article.properties[:slug].type
  end

  expect 255 do
    Article.properties[:slug].size
  end

  expect Article.properties[:slug].to.be.not.nullable?

  expect true do
    Article.properties[:slug].options[:auto_validation]
  end

  expect :unique do
    Article.properties[:slug].index
  end

  expect String do
    Article.properties[:title].type
  end

  expect 255 do
    Article.properties[:title].size
  end

  expect Article.properties[:title].to.be.not.nullable?

  expect true do
    Article.properties[:title].options[:auto_validation]
  end

  expect DataMapper::Types::Text do
    Article.properties[:summary].type
  end

  expect Article.properties[:summary].to.be.not.lazy?

  expect DataMapper::Types::Text do
    Article.properties[:body].type
  end

  expect Article.properties[:body].to.be.lazy?

  expect DateTime do
    Article.properties[:created_at].type
  end

  expect true do
    Article.properties[:created_at].index
  end

  expect DateTime do
    Article.properties[:published_at].type
  end

  expect true do
    Article.properties[:published_at].index
  end

  expect 'some-slug' do
    Article.new(:slug => 'some-slug').slug
  end

  expect 'Some Title' do
    Article.new(:title => 'Some Title').title
  end

  expect 'Some summary.' do
    Article.new(:summary => 'Some summary.').summary
  end

  expect 'Some body.' do
    Article.new(:body => 'Some body.').body
  end

  expect DateTime.now do |expectation|
    Article.new(:created_at => expectation.expected).created_at
  end

  expect DateTime.now do |expectation|
    Article.new(:published_at => expectation.expected).published_at
  end

end
