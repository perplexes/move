module Move
  class Router
    def forward(&block)
      @forward = block
    end
    
    def stop(&block)
      @stop = block
    end
    
    def route!(request)
      request['move.path_parts'] ||= request.path_info.split('/')
      if part = request['move.path_parts'].shift
        @forward.call(part)
      else
        @stop.call(part)
      end
    end
  end
end