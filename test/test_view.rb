require File.dirname(__FILE__) + '/helper.rb'
require 'rack/mock'
require 'rack/request'

describe Move::View do
  before do
    @view = Move::View.new
    @req = Rack::Request.new(Rack::MockRequest.env_for)
  end
  
  it "intializes app and object to nil" do
    @view.app.should.be.nil
    @view.object.should.be.nil
  end
  
  it "calls, then routes" do
    @view.expects(:route).with(@req).returns(true)
    @view.call(@req).should.be.true
  end
  
  it "stubs common http methods" do
    %w(head get put post delete options).each do |method|
      it "stubs #{method}" do
        @view.send(method, @req).should.be.nil
      end
    end
  end
  
  def custom_request(path)
    stub(:path_info => path).tap do |req|
      req.instance_eval do
        def [](key)
          @hash ||= {}
          @hash[key]
        end
      
        def []=(key, val)
          @hash ||= {}
          @hash[key] = val
        end
      end
    end
  end
  
  it "routes forward" do
    req = custom_request('/forward_method')
    @view.expects(:forward).with('forward_method', req).returns(true)
    @view.send(:route, req).should.be.true
  end
  
  it "routes stop" do
    req = custom_request('/')
    @view.expects(:stop).with(req).returns(true)
    @view.send(:route, req).should.be.true
  end
end