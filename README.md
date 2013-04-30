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
#   client = SimpleDigestAuth::Client.new :secret => '123'
#
#   sda.build_signature_for(
#     :request_method => 'GET',
#     :body           => "",
#     :path           => '/',
#     :query_string   => 'foo=bar'
#   )
#   # => "q5o3wVHT1MFlzjViCKi5ZBEbx/aVu0OgFrL707FUAZQ="
#
#   verifier = SimpleDigestAuth::Verifier.new :secret => '123'
#   sda.valid_signature?(
#     :request_method => 'GET',
#     :body           => "",
#     :path           => '/',
#     :query_string   => 'foo=bar',
#     :signature      => "q5o3wVHT1MFlzjViCKi5ZBEbx/aVu0OgFrL707FUAZQ="
#   )
#   # => true
```