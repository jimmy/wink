module Wink
  module Models
    extend self

    MODEL_NAMES = %w[Article Comment]

    def load!
      MODEL_NAMES.each do |model_name|
        load "lib/wink/models/#{model_name.downcase}.rb"
      end
      true
    end

    def unload!
      MODEL_NAMES.each do |model_name|
        Object.send(:remove_const, model_name)
      end
      DataMapper::Resource.descendants.clear
      true
    end

    def reload!
      unload!
      load!
    end

  end
end

Wink::Models.load!

require 'wink/schema'

