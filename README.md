simple_digest_auth
==================

Simple digest authentication client and rack middleware for ruby

```ruby
# inspired by Amazon's AWS auth (also used by Twilio)
# see:
#   * http://www.thebuzzmedia.com/designing-a-secure-rest-api-without-oauth-authentication/
#   * https://github.com/aws/aws-sdk-ruby/blob/master/lib/aws/core/signer.rb
#   * https://github.com/aws/aws-sdk-ruby/blob/master/lib/aws/core/signature/version_4.rb
#   * https://github.com/twilio/twilio-ruby/blob/master/lib/twilio-ruby/util/request_validator.rb
#
#
# Usage:
   client = SimpleDigestAuth::Client.new :secret => '123'

   client.build_signature_for(
     :request_method => 'GET',
     :path           => '/',
     :query_string   => 'foo=bar',
     :body           => ""
   )
   # => "3DxThLjjIi8II30O/uO9Mn0SoLOzOgqVd4Af7qCj9Vs="

   verifier = SimpleDigestAuth::Verifier.new :secret => '123'

   verifier.valid_signature_for_request?(
     :request_method => 'GET',
     :path           => '/',
     :query_string   => 'foo=bar',
     :body           => "",
     :signature      => "3DxThLjjIi8II30O/uO9Mn0SoLOzOgqVd4Af7qCj9Vs="
   )
   # => true
   
   verifier.valid_signature_for_request?(
     :request_method => 'GET',
     :path           => '/',
     :query_string   => 'foo=bar',
     :body           => "",
     :signature      => "sumtin else"
   )
   # => false
```