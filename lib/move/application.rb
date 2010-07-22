module Move
  class Application < View
    def call(env)
      request = Rack::Request.new(env)
      request['router'] = Router.new(request)
      super(request)
    end
  end
end