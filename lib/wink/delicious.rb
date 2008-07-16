require 'time'

module Wink

  # Implements del.icio.us bookmark synchronization.
  class Delicious

    # The del.icio.us username.
    attr_reader :user

    # The del.icio.us password
    attr_reader :password

    # Path to file to use as a cache of all bookmarks. This is used primarily
    # for testing.
    attr_accessor :cache

    # The User-Agent header sent with requests to del.icio.us.
    attr_accessor :user_agent

    def initialize(user, password, options={})
      @user = user
      @password = password
      @cache = options[:cache]
      @user_agent = options[:user_agent] || "Wink/#{Wink::VERSION}"
      @last_updated_at = nil
      yield self if block_given?
    end

    # Open the bookmarks and return an REXML::Document. If the cache option is
    # provided, the document is loaded from the localpath specified.
    def open
      require 'rexml/document'
      xml =
        if cache && File.exist?(cache)
          File.read(cache)
        else
          data = request(:all)
          File.open(cache, 'wb') { |io| io.write(data) } if cache
          data
        end
      REXML::Document.new(xml)
    end

    # The Time of the most recently updated bookmark on del.icio.us.
    def last_updated_at
      if cache
        @last_updated_at ||= Time.iso8601(open.root.attributes['update'])
      else
        remote_last_updated_at
      end
    end

    # Determine if any bookmarks have been updated since the time
    # specified.
    def updated_since?(time)
      time < last_updated_at
    end

    # Yield each bookmark to the block that requires synchronization. The :since
    # option may be specified to indicate the time of the most recently updated
    # bookmark. Only bookmarks whose time is more recent than the time specified
    # are yielded.
    def synchronize(options={})
      if since = options[:since]
        since = since.to_time if since.respond_to? :to_time
        since.utc #!
        return false unless updated_since?(since)
      else
        since = Time.at(0)
        since.utc
      end
      if block_given?
        open.elements.each('posts/post') do |el|
          attributes = el.attributes
          time = Time.iso8601(attributes['time'])
          next if time <= since
          yield :href    => attributes['href'],
            :hash        => attributes['hash'],
            :description => attributes['description'],
            :extended    => attributes['extended'],
            :time        => time,
            :shared      => (attributes['shared'] != 'no'),
            :tags        => attributes['tag'].split(' ')
        end
      else
        require 'enumerator'
        to_enum :synchronize, options
      end
    end

  private

    # A Time object representing when the most recent bookmark was created
    # or updated.
    def remote_last_updated_at
      require 'rexml/document'
      doc = REXML::Document.new(request('update'))
      Time.iso8601(doc.root.attributes['time'])
    end

    def request(method)
      require 'net/https'
      http = Net::HTTP.new('api.del.icio.us', 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = http.start do |http|
        req = Net::HTTP::Get.new("/v1/posts/#{method}", 'User-Agent' => user_agent)
        req.basic_auth(user, password)
        http.request(req)
      end
      res.value
      res.body
    end

  end

end
