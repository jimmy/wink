require 'wink/models/article'
require 'wink/schema'

module Wink
  module Models
    extend self

    def reload!
      Object.send(:remove_const, :Article)
      DataMapper::Resource.descendants.clear
      load 'lib/wink/models/article.rb'
    end
  end
end
