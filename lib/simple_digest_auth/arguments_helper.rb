module SimpleDigestAuth
  module ArgumentsHelper
    def require!(opts, *required_options)
      raise "Must pass a hash of options" unless opts.is_a? Hash
      missing_options = required_options - opts.keys
      raise "Missing required option(s):#{missing_options}" unless missing_options.empty?
    end
    module_function :require!
  end
end