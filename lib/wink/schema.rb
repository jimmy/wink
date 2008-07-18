require 'wink'

module Wink

  # Utility methods for initializing, migrating, and tearing down
  # a Wink database schema.
  module Schema
    extend self

    # Configure the default DataMapper database. This method delegates to 
    # DataMapper::Database::setup but guards against Sinatra reloading.
    def configure(options)
      return if Wink.reloading?
      DataMapper.setup :default, default_database_logger_config.merge(options)
    end

    # TODO: port the ability to set the log_stream and log_level
    # this might help: DataObjects::Sqlite3.logger = DataObjects::Logger.new(STDOUT, 0) 
    def default_database_logger_config
      {
    #    :log_stream => Wink.log_stream,
    #    :log_level => 0
      }
    end

    # TODO: update this comment
    # Create the database schema using the current default DataMapper
    # database. When the :force option is true, drop the table (if it exists)
    # before creating. An exception is raised when :force is false (default) and
    # tables already exist.
    def reset!(options={})
      DataMapper.auto_migrate!
      create_welcome_entry! if options[:welcome]
      true
    end

    # Create the welcome entry. If an existing welcome entry already exists,
    # it is removed.
    def create_welcome_entry!
      remove_welcome_entry!
      Article.create! :slug => 'welcome' do |a|
        a.slug = 'welcome'
        a.title = 'Hiya!'
        a.summary = 'A brief introduction to Wink.'
        a.published = true
        a.body = (<<-end).gsub(/^\s{10}/, '')
          Foo bar baz ...
        end
      end
    end

    # Remove the welcome entry.
    def remove_welcome_entry!
      if article = Article.first(:slug => 'welcome')
        article.destroy
        true
      end
    end
  end

end

# TODO: clean this up
# DEPRECATED: The top-level Database constant will be removed before the next
# release.
Database = Wink::Schema
