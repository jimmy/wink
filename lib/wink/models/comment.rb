require 'rubygems'
require 'dm-core'

# TODO: Deal with fields that are too long.  Consider automatically trimming
# the field or letting the caller deal with the error.  If we want to
# automatically trim the field, perhaps we should extend DataMapper to do it.
class Comment
  include DataMapper::Resource

  property :id,         Serial
  property :article_id, Integer,  :index => true
  property :author,     String,   :size => 80
  property :ip,         String,   :size => 50
  property :url,        String,   :size => 255
  property :body,       Text,     :nullable => false, :lazy => false
  property :created_at, DateTime, :index => true
  property :referrer,   String,   :size => 255
  property :user_agent, String,   :size => 255

  validates_present :article

  belongs_to :article

  def author=(author)
    attribute_set(:author, author.strip)
  end

  def author
    if attribute_get(:author).blank?
      'Anonymous Coward'
    else
      attribute_get(:author)
    end
  end

end
