if !$setup_helper
  # From http://gnufied.org/2008/06/12/making-ruby-bacon-play-with-mocha/
  require "rubygems"
  require "bacon"
  require "mocha/standalone"
  require "mocha/object"
  require "ruby-debug"
  Debugger.start
  
  
  class Module
    def alias_method_chain(target, feature)
      # Strip out punctuation on predicates or bang methods since
      # e.g. target?_without_feature is not a valid method name.
      aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
      yield(aliased_target, punctuation) if block_given?

      with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}", "#{aliased_target}_without_#{feature}#{punctuation}"

      alias_method without_method, target
      alias_method target, with_method

      case
        when public_method_defined?(without_method)
          public target
        when protected_method_defined?(without_method)
          protected target
        when private_method_defined?(without_method)
          private target
      end
    end
  end

  class Bacon::Context
    include Mocha::API
    def it_with_mocha description
      it_without_mocha description do
        mocha_setup
        yield
        mocha_verify
        mocha_teardown
      end
    end
    alias_method_chain :it, :mocha
  end

  require "move"
  $setup_helper = true
end