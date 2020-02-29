# frozen_string_literal: true

module Meta
  module RPC
    # {Client} is the main interface you'll be working with to connect to Meta's
    # RPC server. It opens a single TCP connection to the given +url+ and takes
    # care of encrypting and decrypting the messages using a shared key.
    #
    # @example
    #   client = Meta::RPC::Client.new 'tcp://localhost:31337', 'shared_secret'
    #   params = {
    #     'network' => '*',
    #     'channel' => '#test',
    #     'message' => 'hello, world!'
    #   }
    #
    #   client.call 'message', params
    class Client
      # Constructs a new {Client} that connects to a given +url+ and uses the
      # given +shared_secret+ for message encryption.
      #
      # @param url [String] the URL of the RPC server.
      # @param shared_secret [String] the shared shared_secret used for
      #   encryption.
      #
      # @raise [SharedSecretError] if the provided +shared_secret+ is invalid.
      def initialize url, shared_secret
        @url = URI url
        @shared_secret = shared_secret
        @connection = Connection.new @url.host, @url.port

        @box = RbNaCl::SimpleBox.from_secret_key shared_secret.to_s.b
      rescue RbNaCl::LengthError => e
        raise SharedSecretError, e.message
      end

      # (see Connection#connect)
      def connect
        @connection.connect
      end

      # (see Connection#connected?)
      def connected?
        @connected
      end

      # Sends a remote procedure call +method+ and +params+.
      #
      # @param method [#to_s] the method we want to invoke.
      # @param params [Hash] the parameters we want to invoke the call with.
      #
      # @example
      #   # Send a message in `#test` on all networks where the client is idling
      #   client.call 'message', 'network' => '*', 'channel' => '#test',
      #     'message' => 'hello, world!'
      def call method, params
        json = {
          'method' => method.to_s,
          'params' => params
        }

        @connection.send @box.encrypt MultiJson.dump json
        read_response
      end

      def read_response
        return unless (nonce_and_data = @connection.read_packet)

        @box.decrypt nonce_and_data
      end
    end
  end
end
