Dir[File.dirname(__FILE__) + '/core_extensions/{*,**/*}.rb'].each do |extension_file|
  require extension_file.sub(/\.rb$/, '')
end

