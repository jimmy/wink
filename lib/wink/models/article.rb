require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

class Article
  include DataMapper::Resource

  property :id,           Serial
  property :slug,         String,   :size => 255, :nullable => false, :index => :unique
  property :title,        String,   :size => 255, :nullable => false
  property :summary,      Text,     :lazy => false
  property :body,         Text
  property :created_at,   DateTime, :index => true
  property :published_at, DateTime, :index => true

  def publish
    self.published_at = DateTime.now
  end

  def published?
    published_at.is_a?(DateTime)
  end

  def draft?
    ! published?
  end

end
