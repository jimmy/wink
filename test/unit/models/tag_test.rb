require 'rubygems'
require 'expectations'
require 'wink/models'

Expectations do

  expect Tag.to.be.respond_to?(:for)

  expect Tag.to.receive(:first).with(:name => 'wink') do
    Tag.for('wink')
  end

  expect Tag.to.receive(:first).with(:name => 'wink').returns(Tag.new) do
    Tag.for!('wink')
  end

  expect Tag.to.receive(:create).times(0) do
    Tag.stubs(:first).returns(Tag.new)
    Tag.for!('wink')
  end

  expect Tag.to.receive(:create).with(:name => 'wink') do
    Tag.stubs(:first)
    Tag.for!('wink')
  end

  expect true do
    tag = Tag.new
    tag.stubs(:articles).returns [
      stub_everything(:published? => true),
      stub_everything(:published? => false),
      stub_everything(:published? => true),
      stub_everything(:published? => false)
    ]
    tag.published_articles.all?{|article| article.published?}
  end

end
