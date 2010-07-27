module Move
  class CollectionView < View
    def get(request)
    end

    def post(request)
      @object.create(request.params[object_name])
    end

    def put(request)
      @object.replace(request.params[object_name].map{|p| @object.create(p)})
    end

    def delete(request)
      @object.each(&:destroy)
    end
    
    private
    
    # XXX: This is obviously wrong. Needs pluralize.
    def object_name
      @object.name.split('::').last.downcase + 's'
    end
    
    def forward(id, request)
      if element = @object.find(id) rescue nil
        ElementView.new(@app, element).call(request)
      else
        NotFoundView.new(@app)
      end
    end
  end
  
  class ElementView < View
    def get(request)
    end

    def post(request)
      @object.class.create(request.params[object_name])
    end

    def put(request)
      @object.update(request.params[object_name])
    end

    def delete(request)
      @object.destroy
    end
    
    private
    
    def object_name
      @object.class.name.split('::').last.downcase
    end
    
    def forward(association, request)
      if @object.respond_to(path)
        ElementView.new(@app, @object.send(path)).call(request)
      else
        NotFoundView.new(@app).call(request)
      end
    end
  end
end