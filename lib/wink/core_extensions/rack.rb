require 'rack'

module Rack
  class Request

    # The IP address of the upstream-most client (e.g., the browser). This
    # is reliable even when the request is made through a reverse proxy or
    # other gateway.
    def remote_ip
      @env['HTTP_X_FORWARDED_FOR'] || @env['HTTP_CLIENT_IP'] || @env['REMOTE_ADDR']
    end

  end
end
