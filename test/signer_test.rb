require 'test_helper'

# build a canonical string to represent an HTTP request
lambda do
  opts = {
    :request_method => 'GET',
    :path           => '/a/b/c',
    :query_string   => 'foo=bar',
    :body           => 'data'
  }

  actual = SimpleDigestAuth::Signer.canonical_request_for(opts)
  expected = <<-EOS
GET
/a/b/c
foo=bar
data
EOS
  expected.strip! # get rid of trailing newline from heredoc above

  assert actual, :== => expected
end.call

# Sign with digest using Base64-encoded SHA-256 by default
lambda do
  actual   = SimpleDigestAuth::Signer.sign(:secret => 'my_secret', :payload => 'my_message')
  expected = Base64.encode64(
    OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), 'my_secret', 'my_message')
  ).strip

  assert actual, :== => expected
end.call

# Sign with custom digest method
lambda do
  actual   = SimpleDigestAuth::Signer.sign(:secret => 'my_secret', :payload => 'my_message', :digest_method => 'md5')
  expected = Base64.encode64(
    OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('md5'), 'my_secret', 'my_message')
  ).strip

  assert actual, :== => expected
end.call

# Build signature from secret and HTTP request params
lambda do
  opts = {
    :request_method => 'GET',
    :path           => '/a/b/c',
    :query_string   => 'foo=bar',
    :body           => 'data',
    :secret         => 'my_secret'
  }

  expected = SimpleDigestAuth::Signer.sign :secret  => 'my_secret',
                                           :payload => SimpleDigestAuth::Signer.canonical_request_for(opts)

  actual = SimpleDigestAuth::Signer.build_signature_for_request(opts)

  assert actual, :== => expected
end.call