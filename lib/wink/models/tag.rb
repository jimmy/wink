class Tag
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   :nullable => false, :index => :unique
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_is_unique :name
  alias_method :to_s, :name

  # this is used in one code path, and the sortin happens in the action, so why sort here?
  # plus, many_to_many sti is trikcy
  has n, :entries, :through => Resource,
    :order => [ DataMapper::Query::Direction.new(Entry.properties[:created_at], :desc) ]

  def published_entries
    entries.select{ |entry| entry.published? }
  end

  def published_bookmarks
    published_entries.select{ |entry| entry.is_a?(Bookmark) }
  end

  def published_articles
    published_entries.select{ |entry| entry.is_a?(Article) }
  end

  # When key is a String or Symbol, find a Tag by name; when key is an
  # Integer, find a Tag by id.
  def self.[](key)
    case key
    when String, Symbol then first(:name => key.to_s)
    when Integer        then get!(key)
    else raise TypeError,    "String, Symbol, or Integer key expected"
    end
  end
end
