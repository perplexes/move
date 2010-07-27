module Move
  class View
    attr_reader :app, :object
    def initialize(app = nil, object = nil)
      @app, @object = app, object
      @template = {}
    end
    
    def call(request)
      route(request)
    end
    
    def get(request); end
    def head(request); end
    def post(request); end
    def put(request); end
    def delete(request); end
    def options(request); end
    
    protected
    
    def route(request)
      request['move.path_parts'] ||= request.path_info[1..-1].split('/')
      if part = request['move.path_parts'].shift
        forward(part, request)
      else
        stop(request)
      end
    end
    
    def forward(path, request)
      @template[:content] = if self.respond_to(path)
        self.send(path, request).call(request)
      else
        NotFoundView.new(@app).call(request)
      end
    end
    
    def stop(request)
      respond(request) do
        self.send(request.request_method.downcase, request)
      end
    end
    
    def respond(request) #&b
      accept = request.env['rack-accept.request']
      response = Rack::Response.new

      if accept.media_type?('text/html')
        response['Content-Type'] = 'text/html'
        response.write "<p>Hello. You accept text/html!</p>"
      elsif accept.media_type?('application/json')
        response['Content-Type'] = 'application/json'
        response.write JSON.generate({:json => true})
      elsif accept.media_type?('application/xml')
        response['Content-Type'] = 'application/xml'
        response.write "<hello>Hello. You accept application/json!</hello>"
      else
        response['Content-Type'] = 'text/plain'
        response.write "Apparently you don't accept text/html. Too bad."
      end

      response.finish
    end
  end
end