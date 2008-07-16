class Bookmark < Entry

  def stem
    "linkings/#{slug}"
  end

  def filter
    'markdown'
  end

  # Synchronize bookmarks with del.icio.us. The :delicious configuration option
  # must be set to a two-tuple of the form: ['username','password']. Returns the
  # number of bookmarks synchronized when successful or nil if del.icio.us
  # synchronization is disabled.
  def self.synchronize(options={})
    return nil if Wink[:delicious].nil?
    options.each { |key,val| delicious.send("#{key}=", val) }
    count = 0

    delicious.synchronize :since => last_updated_at do |source|

      # skip URLs matching the delicious_filter regexp
      next if Wink.delicious_filter && source[:href] =~ Wink.delicious_filter

      # skip private bookmarks
      next unless source[:shared]

      bookmark = find_or_create(:slug => source[:hash])
      bookmark.attributes = {
        :url        => source[:href],
        :title      => source[:description],
        :summary    => source[:extended],
        :body       => source[:extended],
        :filter     => 'text',
        :created_at => source[:time].getlocal,
        :updated_at => source[:time].getlocal,
        :published  => 1
      }
      bookmark.tag_names = source[:tags]
      bookmark.save
      count += 1

      # HACK: DataMapper wants to overwrite the created_at date we
      # set explicitly when creating a new record.
      bookmark.created_at = source[:time].getlocal
      bookmark.save

    end

    count
  end

  def self.delicious
    require 'wink/delicious'
    connection = Wink::Delicious.new(*Wink[:delicious])
    (class <<self;self;end).send(:define_method, :delicious) { connection }
    connection
  end

  # The Time of the most recently updated Bookmark in UTC.
  def self.last_updated_at
    latest && latest.created_at
  end

end
