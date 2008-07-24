require 'rubygems'
require 'expectations'
require 'wink/models/article'
require 'wink/models/comment'

Expectations do

  expect true do
    Comment.new.is_a?(DataMapper::Resource)
  end

  expect Comment.properties[:id].to.be.serial?

  expect Comment.properties[:id].to.be.key?

  expect Integer do
    Comment.properties[:article_id].type
  end

  expect Comment.properties[:article_id].to.be.index

  expect true do
    Comment.properties[:article_id].options[:auto_validation]
  end

  expect Comment.new.to.be.respond_to?(:article)

  expect String do
    Comment.properties[:author].type
  end

  expect 80 do
    Comment.properties[:author].size
  end

  expect 'Frankie' do
    comment = Comment.new(:author => '  Frankie  ')
    comment[:author]
  end

  expect 'Anonymous Coward' do
    Comment.new(:author => '').author
  end

  expect 'Frankie' do
    Comment.new(:author => 'Frankie').author
  end

  expect String do
    Comment.properties[:ip].type
  end

  expect 50 do
    Comment.properties[:ip].size
  end

  expect String do
    Comment.properties[:url].type
  end

  expect 255 do
    Comment.properties[:url].size
  end

  expect DataMapper::Types::Text do
    Comment.properties[:body].type
  end

  expect Comment.properties[:body].to.be.not.nullable?

  expect Comment.properties[:body].to.be.not.lazy?

  expect DateTime do
    Article.properties[:created_at].type
  end

  expect true do
    Article.properties[:created_at].index
  end

  expect String do
    Comment.properties[:referrer].type
  end

  expect 255 do
    Comment.properties[:referrer].size
  end

  expect String do
    Comment.properties[:user_agent].type
  end

  expect 255 do
    Comment.properties[:user_agent].size
  end

end
