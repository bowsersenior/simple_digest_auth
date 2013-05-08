require 'test_helper'
require 'simple_digest_auth/verifier'

subject = SimpleDigestAuth::Verifier.new :secret => 'shhhh'

# valid_signature_for_request? returns true if signature matches request
lambda do
  client = SimpleDigestAuth::Client.new :secret => 'shhhh'
  opts = {
    :request_method => 'GET',
    :path           => '/a/b/c',
    :query_string   => 'foo=bar',
    :body           => 'data'
  }

  opts.merge!(:signature => client.build_signature_for(opts))

  assert subject.valid_signature_for_request?(opts), :== => true

  opts[:body] = 'woot'
  assert subject.valid_signature_for_request?(opts), :== => false
end.call
