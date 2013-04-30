require 'simple_digest_auth/arguments_helper'
require 'simple_digest_auth/client'

module SimpleDigestAuth
  class Verifier
    attr_accessor :client

    def initialize(opts={})
      ArgumentsHelper.require! opts, :secret

      self.client = Client.new(opts)
    end

    def valid_signature_for_request?(opts={})
      ArgumentsHelper.require! opts, :request_method, :body, :path, :query_string, :signature

      opts = opts.dup

      received_signature = opts.delete(:signature)
      calculated_signature = self.client.build_signature_for(opts)

      # Direct string comparison is vulnerable to timing attacks, compare hashes instead
      # see: http://blog.jcoglan.com/2012/06/09/
      Digest::SHA1.hexdigest(received_signature) === Digest::SHA1.hexdigest(calculated_signature)
    end
  end
end