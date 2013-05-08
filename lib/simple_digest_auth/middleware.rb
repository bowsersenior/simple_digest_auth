require 'simple_digest_auth/verifier'
require 'simple_digest_auth/arguments_helper'

module SimpleDigestAuth
  class Middleware
    def initialize(app, opts={})
      ArgumentsHelper.require! opts, :header_name, :secret

      @app = app
      @header_name = opts[:header_name]
      @verifier = SimpleDigestAuth::Verifier.new(:secret => opts[:secret])
    end

    def call(env)
      if @verifier.valid_signature_for_request?( request_opts_for(env) )
        @app.call(env)
      else
        unauthorized_response
      end
    end
    private
    def unauthorized_response
      [ 401, {}, [""] ]
    end

    def request_opts_for(env)
      {
        :request_method => env['REQUEST_METHOD'],
        :path           => env['PATH_INFO'],
        :query_string   => env['QUERY_STRING'],
        :body           => env['rack.input'].read,
        :signature      => env[@header_name]
      }
    end

  end
end
