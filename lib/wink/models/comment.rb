class Comment
  include DataMapper::Resource

  property :id,         Serial
  property :author,     String,   :size => 80
  property :ip,         String,   :size => 50
  property :url,        String,   :size => 255
  property :body,       Text,     :nullable => false, :lazy => false
  property :created_at, DateTime, :index => true
  property :referrer,   String,   :size => 255
  property :user_agent, String,   :size => 255
  property :checked,    Boolean,  :default => false
  property :spam,       Boolean,  :default => false, :index => true
  property :entry_id,   Integer,  :index => true

  belongs_to :entry

  validates_present :body, :entry_id

  before :create do
    check
    true
  end

  def self.ham(options={})
    all({:spam.not => true, :order => [:created_at.desc]}.merge(options))
  end

  def self.spam(options={})
    all({:spam => true, :order => [:created_at.desc]}.merge(options))
  end

  def excerpt(length=65)
    body.to_s.gsub(/[\s\r\n]+/, ' ')[0..length] + " ..."
  end

  def body=(text)
    # the first sub autolinks URLs when on line by itself; the second sub
    # disables escapes markdown's headings when followed by a number.
    body = text.to_s.dup
    body.gsub!(/^https?:\/\/\S+$/, '<\&>')
    body.gsub!(/^(\s*)(#\d+)/) { [$1, "\\", $2].join }
    body.gsub!(/\r/, '')
    self[:body] = body
  end

  def url=(url)
    stripped_url = url.strip
    self[:url] = stripped_url.blank? ? url : stripped_url
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
    if self[:author].blank?
      'Anonymous Coward'
    else
      self[:author]
    end
  end

  # Check the comment with Akismet. The spam attribute is updated to reflect
  # whether the spam was detected or not.
  def check
    return true if self[:checked]
    self[:checked] = true
    self[:spam] = blacklisted? || akismet(:check) || false
  rescue => boom
    logger.error "An error occured while connecting to Akismet: #{boom.to_s}"
    self[:checked] = false
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
    self[:checked] = true
    self[:spam] = true
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
    self[:checked] = true
    self[:spam] = false
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
