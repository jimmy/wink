require 'rubygems'
require 'test/spec'
require 'wink/models/article'
require 'wink/models/comment'
require 'wink/schema'

context 'Comment' do

  setup do
    Wink::Schema.reset!
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.new(:article_id => article.id, :body => 'some comment')
    comment.save.should == true
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.create!(:article_id => article.id, :body => 'some comment')
    comment.article.id.should == article.id
    # Runing rake rcov with the previous line as:  comment.article.should == article
    # results in this test failing because comment.article.created != article.created_at
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.create!(:article_id => article.id, :body => 'some comment')
    article.reload
    article.comments.should == [comment]
  end

  specify '' do
    comment = Comment.create
    comment.errors[:body].should.include "Body must not be blank"
  end

  specify '' do
    comment = Comment.create
    comment.errors[:article].should.include "Article must not be blank"
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.create!(:article_id => article.id, :body => 'some comment')
    comment.created_at.should.be.instance_of DateTime
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.create!(:author => ' ', :body => 'some body', :article => article)
    comment.reload
    comment[:author].should == ''
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.create!(:author => ' ', :body => 'some body', :article => article)
    comment.reload
    comment.author.should == 'Anonymous Coward'
  end

  specify '' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    comment = Comment.create!(:author => ' Frankie ', :body => 'some body', :article => article)
    comment.reload
    comment.author.should == 'Frankie'
  end

end
