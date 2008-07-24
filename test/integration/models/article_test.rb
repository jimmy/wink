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

context 'Article: custom finders' do

  setup do
    Wink::Schema.reset!

    # create 8 drafts
    8.times do |i|
      article = Article.create!(:slug => i, :title => i)
      article.created_at = DateTime.parse("2008-01-01") + i
      article.save
    end

    # publish 4 of articles
    Article.all(:limit => 4).each_with_index do |article, index|
      article.published_at = DateTime.parse("2008-01-01") + index
      article.save
    end
  end

  specify 'published should only return published articles' do
    Article.published.should.be.all{ |article| article.published? }
  end

  specify 'published should be ordered by published_at desc' do
    published_ats = Article.published.map{ |article| article.published_at }
    published_ats.should == published_ats.sort.reverse
  end

  specify 'published should merge options' do
    published_ats = Article.published(:order => [:published_at]).map{ |article| article.published_at }
    published_ats.should == published_ats.sort
  end

  specify 'drafts should only return unpublished articles' do
    Article.drafts.should.be.all{ |article| article.draft? }
  end

  specify 'drafts should be ordered by created_at desc' do
    created_ats = Article.drafts.map{ |article| article.created_at }
    created_ats.should == created_ats.sort.reverse
  end

  specify 'drafts should merge options' do
    created_ats = Article.drafts(:order => [:created_at]).map{ |article| article.created_at }
    created_ats.should == created_ats.sort
  end

  specify 'circa should only return articles from the given year' do
    Article.create!(:slug => '2009', :title => '2009', :published_at => DateTime.parse("2009-01-01"))
    Article.circa(2008).should.be.all{ |article| article.published_at.year == 2008 }
  end

  specify 'circa should only return published articles' do
    Article.circa(2008).should.be.all{ |article| article.published? }
  end

  specify 'circa should be ordered by published_at' do
    published_ats = Article.circa(2008).map{ |article| article.published_at }
    published_ats.should == published_ats.sort
  end

  specify 'circa should merge options' do
    created_ats = Article.circa(2008, :order => [:created_at]).map{ |article| article.created_at }
    created_ats.should == created_ats.sort
  end
end
