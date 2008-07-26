class Tag
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :nullable => false, :index => :unique

  has n, :articles, :through => Resource,
    :order => [
      DataMapper::Query::Direction.new(Article.properties[:published_at], :desc),
      DataMapper::Query::Direction.new(Article.properties[:created_at], :desc),
    ]

  def published_articles
    articles.select{ |article| article.published? }
  end

  def self.for(name)
    first(:name => name)
  end

  def self.for!(name)
    first(:name => name) || create(:name => name)
  end

end
