require 'test_helper'
require 'simple_digest_auth/client'

subject = SimpleDigestAuth::Client.new(:secret => 'shhhh')

# build a signature from HTTP request using the secret
lambda do
  opts = {
    # format expected by SimpleDigestAuth::Signer.canonical_request_for
  }

  stub(SimpleDigestAuth::Signer, :spy => :build_signature_for_request, :return => 'foo') do
    assert subject.build_signature_for(opts), :== => 'foo'
  end
end.call
