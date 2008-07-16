class Tag
  include DataMapper::Persistence

  property :id, :integer, :serial => true
  property :name, :string, :nullable => false, :index => :unique
  property :created_at, :datetime, :nullable => false
  property :updated_at, :datetime, :nullable => false

  validates_uniqueness_of :name
  alias_method :to_s, :name

  has_and_belongs_to_many :entries,
    :conditions => { :published => true },
    :order => "(entries.type = 'Bookmark') ASC, entries.created_at DESC",
    :join_table => 'taggings'

  # When key is a String or Symbol, find a Tag by name; when key is an
  # Integer, find a Tag by id.
  def self.[](key)
    case key
    when String, Symbol then first(:name => key.to_s)
    when Integer        then super
    else raise TypeError,    "String, Symbol, or Integer key expected"
    end
  end
end
