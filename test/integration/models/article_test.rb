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
    article = Article.create(:slug => '')
    article.errors[:slug].should.include "Slug must not be blank"
  end

  specify '' do
    article = Article.create(:title => '')
    article.errors[:title].should.include "Title must not be blank"
  end

  specify '' do
    article = Article.create!(
      :slug    => 'some-slug',
      :title   => 'Some Title'
    )
    article.created_at.should.be.instance_of(DateTime)
  end

  specify '' do
    article = Article.new(
      :slug    => 'some-slug',
      :title   => 'Some Title'
    )
    article.publish
    article.save
    article.reload
    article.should.be.published
    article.should.not.be.draft
    article.published_at.class.should == DateTime
  end

end
