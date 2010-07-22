# XXX: Move to bundler
require 'rubygems'
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

require_relative 'move/application'
require_relative 'move/model_views'
require_relative 'move/application'
