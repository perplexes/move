module Move
  class Template
    def initialize(object)
      @object = object
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