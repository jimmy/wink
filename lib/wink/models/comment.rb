class Comment
  include DataMapper::Persistence

  property :id, :integer, :serial => true
  property :author, :string, :size => 80
  property :ip, :string, :size => 50
  property :url, :string, :size => 255
  property :body, :text, :nullable => false, :lazy => false
  property :created_at, :datetime, :nullable => false, :index => true
  property :referrer, :string, :size => 255
  property :user_agent, :string, :size => 255
  property :checked, :boolean, :default => false
  property :spam, :boolean, :default => false, :index => true

  belongs_to :entry
  index [ :entry_id ]

  validates_presence_of :body, :entry_id

  before_create do |comment|
    comment.check
    true
  end

  def self.ham(options={})
    all({:spam.not => true, :order => 'created_at DESC'}.merge(options))
  end

  def self.spam(options={})
    all({:spam => true, :order => 'created_at DESC'}.merge(options))
  end

  def excerpt(length=65)
    body.to_s.gsub(/[\s\r\n]+/, ' ')[0..length] + " ..."
  end

  def body=(text)
    # the first sub autolinks URLs when on line by itself; the second sub
    # disables escapes markdown's headings when followed by a number.
    @body = text.to_s
    @body.gsub!(/^https?:\/\/\S+$/, '<\&>')
    @body.gsub!(/^(\s*)(#\d+)/) { [$1, "\\", $2].join }
    @body.gsub!(/\r/, '')
  end

  def url
    # TODO move this kind of logic into the setter
    @url.strip unless @url.to_s.strip.blank?
  end

  def author_link
    case url
    when nil                         then nil
    when /^mailto:.*@/, /^https?:.*/ then url
    when /@/                         then "mailto:#{url}"
    else                                  "http://#{url}"
    end
  end

  def author_link?
    !author_link.nil?
  end

  def author
    if @author.blank?
      'Anonymous Coward'
    else
      @author
    end
  end

  # Check the comment with Akismet. The spam attribute is updated to reflect
  # whether the spam was detected or not.
  def check
    return true if @checked
    @checked = true
    @spam = blacklisted? || akismet(:check) || false
  rescue => boom
    logger.error "An error occured while connecting to Akismet: #{boom.to_s}"
    @checked = false
  end

  # Check the comment with Akismet and immediately save the comment.
  def check!
    check
    save
  end

  # True when the comment matches any of the blacklisted patterns.
  def blacklisted?
    Array(Wink.comment_blacklist).any? { |pattern| pattern === body }
  end

  # Has the current comment been marked as spam?
  def spam?
    !! spam
  end

  # Mark this comment as Spam and immediately save the comment. If Akismet is
  # enabled, the comment is submitted as spam.
  def spam!
    @checked = @spam = true
    akismet :spam!
    save
  end

  # Opposite of #spam? -- true when the comment has not been marked as
  # spam.
  def ham?
    ! spam
  end

  # Mark this comment as Ham and immediately save the comment. If Akismet is
  # enabled, the comment is submitted as Ham.
  def ham!
    @checked, @spam = true, false
    akismet :ham!
    save
  end

private

  # Should comments be checked with Akismet before saved?
  def akismet?
    Wink.akismet_key && (Wink.production? || Wink.akismet_always)
  end

  # Send an Akismet request with parameters from the receiver's model. Return
  # nil when Akismet is not enabled.
  def akismet(method, extra={})
    akismet_connection.__send__(method, akismet_params(extra)) if akismet?
  end

  # Build a Hash of Akismet parameters based on the properties of the receiver.
  def akismet_params(others={})
    { :user_ip            => ip,
      :user_agent         => user_agent,
      :referrer           => referrer,
      :permalink          => entry.permalink,
      :comment_type       => 'comment',
      :comment_author     => author,
      :comment_author_url => url,
      :comment_content    => body }.merge(others)
  end

  # The Wink::Akismet instance used for checking comments.
  def akismet_connection
    @akismet_connection ||=
      begin
        require 'wink/akismet'
        Wink::Akismet::new(Wink.akismet_key, Wink.akismet_url)
      end
  end

end
