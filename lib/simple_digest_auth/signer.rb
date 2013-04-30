require 'openssl'
require 'base64'
require 'simple_digest_auth/arguments_helper'

module SimpleDigestAuth
  module Signer
    def canonical_request_for(opts={})
      ArgumentsHelper.require! opts, :request_method, :body, :path, :query_string

      [
        opts[:request_method],
        opts[:path],
        opts[:query_string],   # GET params
        opts[:body]            # POST params
      ].join("\n")
    end

    def sign(opts={})
      ArgumentsHelper.require! opts, :secret, :payload

      digest_method = opts[:digest_method] || 'sha256'

      digest = OpenSSL::Digest::Digest.new(digest_method)
      Base64.encode64(
        OpenSSL::HMAC.digest(digest, opts[:secret], opts[:payload])
      ).strip
    end

    def build_signature_for_request(opts={})
      self.sign :secret  => opts[:secret],
                :payload => self.canonical_request_for(opts)
    end

    module_function :canonical_request_for, :sign, :build_signature_for_request
  end
end