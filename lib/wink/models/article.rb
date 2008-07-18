class Article < Entry

  # this is almost identical to Bookmark.tagged
  def self.tagged(tag_name)
    if tag = Tag[tag_name]
      tag.published_articles
    else
      []
    end
  end

end
