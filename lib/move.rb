require "rubygems"
require "bundler"
Bundler.setup

require 'callsite'
Callsite.activate_module_methods

module Move
  autoload_relative :Application, 'move/application'
  autoload_relative :CollectionView, 'move/model_views'
  autoload_relative :ElementView, 'move/model_views'
  autoload_relative :Router, 'move/router'
  autoload_relative :Template, 'move/template'
  autoload_relative :View, 'move/view'
end
