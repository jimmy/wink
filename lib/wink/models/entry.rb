class Entry
  include DataMapper::Persistence

  property :id, :integer, :serial => true
  property :slug, :string, :size => 255, :nullable => false, :index => :unique
  property :type, :class, :nullable => false, :index => true
  property :published, :boolean, :default => false
  property :title, :string, :size => 255, :nullable => false
  property :summary, :text, :lazy => false
  property :filter, :string, :size => 20, :default => 'markdown'
  property :url, :string, :size => 255
  property :created_at, :datetime, :nullable => false, :index => true
  property :updated_at, :datetime, :nullable => false
  property :body, :text

  validates_presence_of :title, :slug, :filter

  has_many :comments,
    :spam.not => true,
    :order => 'created_at ASC'

  has_and_belongs_to_many :tags,
    :join_table => 'taggings'

  def initialize(attributes={})
    @created_at = DateTime.now
    @filter = 'markdown'
    super
    yield self if block_given?
  end

  def stem
    "writings/#{slug}"
  end

  def permalink
    "#{Wink.url}/#{stem}"
  end

  def domain
    if url && url =~ /https?:\/\/([^\/]+)/
      $1.strip.sub(/^www\./, '')
    end
  end

  def created_at=(value)
    value = value.to_datetime if value.respond_to?(:to_datetime)
    @created_at = value
  end

  def updated_at=(value)
    value = value.to_datetime if value.respond_to?(:to_datetime)
    @updated_at = value
  end

  def published?
    !! published
  end

  def published=(value)
    value = ! ['false', 'no', '0', ''].include?(value.to_s)
    self.created_at = self.updated_at = DateTime.now if value && draft? && !new_record?
    @published = value
  end

  def publish!
    self.published = true
    save
  end

  def draft?
    ! published
  end

  def body?
    ! body.blank?
  end

  def tag_names=(value)
    tags.clear
    tag_names =
      if value.respond_to?(:to_ary)
        value.to_ary
      elsif value.respond_to?(:to_str)
        value.split(/[\s,]+/)
      end
    tag_names.uniq.each do |tag_name|
      tag = Tag.find_or_create(:name => tag_name)
      tags << tag
    end
  end

  def tag_names
    tags.collect { |t| t.name }
  end

  def self.published(options={})
    options = { :order => 'created_at DESC', :published => true }.
      merge(options)
    all(options)
  end

  def self.drafts(options={})
    options = { :order => 'created_at DESC', :published => false }.
      merge(options)
    all(options)
  end

  def self.circa(year, options={})
    options = {
      :created_at.gte => Date.new(year, 1, 1),
      :created_at.lt => Date.new(year + 1, 1, 1),
      :order => 'created_at ASC'
    }.merge(options)
    published(options)
  end

  def self.tagged(tag, options={})
    if tag = Tag.first(:name => tag)
      tag.entries
    else
      []
    end
  end

  # The most recently published Entry (or specific subclass when called on
  # Article, Bookmark, or other Entry subclass).
  def self.latest(options={})
    first({ :order => 'created_at DESC', :published => true }.merge(options))
  end

  # XXX The following two methods shouldn't be necessary but DM isn't adding
  # the type condition.

  def self.first(options={}) #:nodoc:
    return super if self == Entry
    options = { :type => ([self] + self::subclasses.to_a) }.
      merge(options)
    super(options)
  end

  def self.all(options={}) #:nodoc:
    return super if self == Entry
    options = { :type => ([self] + self::subclasses.to_a) }.
      merge(options)
    super(options)
  end

  # XXX neither ::create or ::create! pass the block parameter to ::new so
  # we need to override to fix that.

  def self::create(attributes={}, &block) #:nodoc:
    instance = new(attributes, &block)
    instance.save
    instance
  end

  def self::create!(attributes={}, &block) #:nodoc:
    instance = create(attributes, &block)
    raise DataMapper::InvalidRecord, instance if instance.errors.any?
    instance
  end

end
