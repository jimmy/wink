require 'sinatra'

# TODO [jimmy]: Move this to a more appropriate location.
module Wink
  extend self

  # The running environment as a Symbol; obtained from Sinatra's
  # application options.
  def environment
    Sinatra.env.to_sym
  end
  
  # Are we currently running under the production environment?
  def production?
    environment == :production
  end
  
  # Are we currently running under the development environment?
  def development?
    environment == :development
  end
  
  # Truthful when the application is in the process of being reloaded
  # by Sinatra.
  def reloading?
    Sinatra.application.reloading?
  end

end
