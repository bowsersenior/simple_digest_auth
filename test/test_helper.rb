$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'simple_digest_auth'
require 'tmf'

include TMF