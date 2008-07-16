class Tagging #:nodoc:
  include DataMapper::Persistence

  belongs_to :entry
  belongs_to :tag
  index [:entry_id]
  index [:tag_id]
end

