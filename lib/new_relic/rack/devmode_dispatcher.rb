# A middleware for handling devmode requests
# If this were a Rails Metal, then it would return
# 404 for unknown routes.  As a middleware, it needs
# to just defer to the called app
class NewRelic::Rack::DevmodeDispatcher
  # If no inner app is specified, then this might be
  # a rails metal.  Return 404 if the route doesn't match.
  def initialize(app=nil)  
    @app = app
  end
  
  def call(env)
    request = ::Rack::Request.new env
    # Pass on the request to the next layer in the middleware
    response = @app.call(env)
    # post process the response by filtering the content part
    # of the vector
    [ response[0], response[1], ContentWrapper.new(response[2]) ]
  end
  
  class ContentWrapper
    def initialize(response)
      @response = response
    end
    def each
      v = @response.each
      # Insert something here or just return v
      v
    end
  end
  
end
