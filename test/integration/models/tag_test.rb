require 'rubygems'
require 'test/spec'
require 'wink/models'
require 'wink/schema'

context 'Tag' do

  setup do
    Wink::Schema.reset!
  end

  # this seems to be a bug in DataMapper
  xspecify 'should be able to clear and save tags' do
    article = Article.create!(:slug => 'slug', :title => 'title')
    wink = Tag.create!(:name => 'wink')
    article.tags << wink
    article.save
    article.reload
    article.tags.clear
    article.tags << wink
    article.save
    article.tags.should == [wink]
  end

  specify '.for should return nil for nonexistent tags' do
    Tag.for('wink').should.be.nil
  end

  specify '.for should return existing tag' do
    wink_tag = Tag.create(:name => 'wink')
    Tag.for('wink').should == wink_tag
  end

  specify '.for! should create tag when necessary' do
    wink_tag = Tag.for!('wink')
    Tag.all.should == [wink_tag]
  end

  specify '.for! should return existing tag' do
    wink_tag = Tag.create(:name => 'wink')
    Tag.for!('wink').id.should == wink_tag.id
  end

  specify '.articles should order by published_at desc, created_at desc' do
    Tag.create!(:name => 'wink')
    Tag.create!(:name => 'notwink')

    now = DateTime.now
    [
      ['1',  nil    , now + 1],
      ['2',  nil    , now + 3],
      ['3',  now + 5, now + 4],
      ['4',  now + 6, now + 2],
    ].each do |order, published_at, created_at|
      article = Article.create!(
        :slug => order,
        :title => order,
        :created_at => created_at,
        :published_at => published_at
      )
      article.tags << Tag.for('wink')
      article.save
    end

    Tag.for('wink').articles.map{|a| a.slug}.should == %w[4 3 2 1]
    Tag.for('notwink').articles.should.be.empty

    Tag.for('wink').published_articles.map{|a| a.slug}.should == %w[4 3]
    Tag.for('notwink').published_articles.should.be.empty
  end
end
