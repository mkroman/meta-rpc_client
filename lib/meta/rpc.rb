# frozen_string_literal: true

require 'uri'
require 'socket'
require 'timeout'

require 'rbnacl'
require 'multi_json'

require_relative './rpc/client'
require_relative './rpc/connection'
require_relative './rpc/version'

module Meta
  module RPC
    # Error type that indicates there was something wrong with the format of the
    # shared secret.
    class SharedSecretError < StandardError; end
    class ConnectionError < StandardError; end
    class ReadTimeoutError < StandardError; end
  end
end
