require 'test_helper'
require 'rack'
require 'simple_digest_auth/middleware'

app = Rack::Builder.new do
  use SimpleDigestAuth::Middleware, :header_name => 'X-Foo-Bar', :secret => 'abc123'
  run lambda { |env|  [ 200 , {}, ['foo'] ] }
end

# returns a 400 when no signature is set in header
lambda do
  response = Rack::MockRequest.new(app).get('/')
  assert response.status, :== => 401
end.call

client = SimpleDigestAuth::Client.new(:secret => 'abc123')
signature = client.build_signature_for(
  :request_method => 'GET',
  :path           => '/foo',
  :query_string   => 'fee=fi',
  :body           => 'fofum'
)

# calls the next app when valid signature is set in header
lambda do
  response = Rack::MockRequest.new(app).get('/foo?fee=fi',
    :input      => 'fofum',
    'X-Foo-Bar' => signature
  )
  assert response.status, :== => 200
  assert response.body, :== => 'foo'
end.call

# returns a 400 when invalid signature is set in header
lambda do
  response = Rack::MockRequest.new(app).get('/foo?fee=fi',
    :input      => 'fofum',
    'X-Foo-Bar' => 'signature'
  )
  assert response.status, :== => 401
end.call
