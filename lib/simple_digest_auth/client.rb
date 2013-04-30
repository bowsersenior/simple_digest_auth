require 'simple_digest_auth/arguments_helper'
require 'simple_digest_auth/signer'

module SimpleDigestAuth
  class Client
    attr_accessor :secret

    def initialize(opts={})
      ArgumentsHelper.require! opts, :secret

      self.secret = opts[:secret]
    end

    def build_signature_for(opts)
      Signer.build_signature_for_request( opts.merge(:secret => self.secret) )
    end
  end
end