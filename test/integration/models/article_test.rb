require 'rubygems'
require 'test/spec'
require 'wink/models/article'
require 'wink/schema'

context 'Article' do

  setup do
    Wink::Schema.reset!
  end

  specify '' do
    article = Article.new(
      :slug    => 'some-slug',
      :title   => 'Some Title'
    )

    article.save.should == true
  end

  specify '' do
    article = Article.new(
      :title => 'Some Title'
    )

    e = assert_raise(Sqlite3Error){ article.save }
    e.message.should == 'articles.slug may not be NULL'
  end

  specify '' do
    article = Article.new(
      :slug  => '',
      :title => 'Some Title'
    )

    article.save.should == true
  end

  specify '' do
    article = Article.new(
      :slug => 'some-slug'
    )

    e = assert_raise(Sqlite3Error){ article.save }
    e.message.should == 'articles.title may not be NULL'
  end

  specify '' do
    article = Article.new(
      :slug => 'some-slug',
      :title => ''
    )

    article.save.should == true
  end

end
