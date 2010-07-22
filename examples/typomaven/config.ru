require 'rack/accept'

use Rack::Accept
run TypoMaven.new