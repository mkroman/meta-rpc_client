# frozen_string_literal: true

module Meta
  module RPC
    class Connection
      # @return [String] the user-specified host we're connecting to.
      attr_reader :host

      # @return [Integer] the user-specified port we're connecting on.
      attr_reader :port

      # Creates a new (not yet connected) connection.
      def initialize host, port
        @host = host
        @port = port
        @socket = nil
        @buffer = +''
        @connected = false
      end

      # Opens a TCP connection to the host.
      #
      # @return [Boolean] +true+ if connection succeeds, +false+ otherwise.
      def connect
        @socket = TCPSocket.open @host, @port
        @connected = !@socket.closed?
      end

      # @return [Boolean] true if we're connected, false otherwise.
      def connected?
        @connected
      end

      # Sends the given +data+ to the RPC server.
      #
      # @note if the data is malformed, the server will immediately close the
      #   connection.
      def send data
        data = [data.bytesize, *data.bytes].pack 'NC*'

        @socket.send data, 0
      end

      # Reads exactly +size+ number of bytes by blocking until the requested
      # amount of bytes have been received.
      #
      # @param [Integer] size number of bytes to read.
      #
      # @raise [ConnectionError] if the connection was closed
      def read size
        until @buffer.bytesize >= size
          result = @socket.recv size
          result.bytesize

          unless result.bytesize.positive?
            raise ConnectionError, 'num_recv <= 0'
          end

          @buffer << result
        end

        @buffer.slice! 0, size
      end

      def read_packet timeout = 30
        Timeout.timeout timeout, ReadTimeoutError do
          packet_size = read(4).unpack1 'N'
          _packet = read packet_size
        end
      end
    end
  end
end
