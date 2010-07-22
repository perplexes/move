module Move
  class View
    def initialize(app = nil, object = nil)
      @app = app, @object = object
      @template = Template.new(self)
    end
    
    def call(request)
      route request do |router|
        router.forward do |path|
          @template.content = forward(path, request)
        end
        
        router.stop{ stop(request) }
      end
    end
    
    def get(request); end
    def head(request); end
    def post(request); end
    def put(request); end
    def delete(request); end
    def options(request); end
    
    protected
    
    def route(request)
      yield @router = Router.new
      @router.route!(request)
    end
    
    def forward(path, request)
      if self.respond_to(path)
        self.send(path, request).call(request)
      else
        NotFoundView.new(@app).call(request)
      end
    end
    
    def stop(request)
      @template.respond(request) do
        self.send(request.request_method.downcase, request)
      end
    end
  end
end