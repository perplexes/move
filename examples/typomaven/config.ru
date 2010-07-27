require 'rack/accept'
require 'app'

use Rack::Accept
run TypoMaven.new