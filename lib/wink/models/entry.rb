class Entry
  include DataMapper::Resource

  property :id,         Serial
  property :slug,       String,        :size => 255, :nullable => false, :index => :unique
  property :class_type, Discriminator, :index => true
  property :published,  Boolean,       :default => false
  property :title,      String,        :size => 255, :nullable => false
  property :summary,    Text,          :lazy => false
  property :filter,     String,        :size => 20, :default => 'markdown'
  property :url,        String,        :size => 255
  property :created_at, DateTime,      :index => true
  property :updated_at, DateTime
  property :body,       Text

  validates_present :title, :slug, :filter

  has n, :comments,
    :spam.not => true,
    :order => [:created_at.asc]

  has n, :tags, :through => Resource

  def initialize(attributes={})
    self[:created_at] = DateTime.now
    self[:filter] = 'markdown'
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
    self[:created_at] = value
  end

  def updated_at=(value)
    value = value.to_datetime if value.respond_to?(:to_datetime)
    self[:updated_at] = value
  end

  def published?
    !! published
  end

  def published=(value)
    value = ! ['false', 'no', '0', ''].include?(value.to_s)
    self.created_at = self.updated_at = DateTime.now if value && draft? && !new_record?
    self[:published] = value
  end

  def publish!
    self.published = true
    save!
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
    options = { :order => [:created_at.desc], :published => true }.
      merge(options)
    all(options)
  end

  def self.drafts(options={})
    options = { :order => [:created_at.desc], :published => false }.
      merge(options)
    all(options)
  end

  def self.circa(year, options={})
    options = {
      :created_at.gte => Date.new(year, 1, 1),
      :created_at.lt => Date.new(year + 1, 1, 1),
      :order => [:created_at.asc]
    }.merge(options)
    published(options)
  end

  # The most recently published Entry (or specific subclass when called on
  # Article, Bookmark, or other Entry subclass).
  def self.latest(options={})
    first({ :order => [:created_at.desc], :published => true }.merge(options))
  end

  # XXX neither ::create or ::create! pass the block parameter to ::new so
  # we need to override to fix that.
  # TODO: consider moving these next two methods into core_extensions/data_mapper
  def self::create(attributes={}, &block) #:nodoc:
    instance = new(attributes, &block)
    instance.save
    instance
  end

  def self::create!(attributes={}, &block) #:nodoc:
    instance = new(attributes, &block)
    instance.save!
    instance
  end

end
