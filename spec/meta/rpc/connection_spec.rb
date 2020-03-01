# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Meta::RPC::Connection do
  let(:host) { 'localhost' }
  let(:port) { 31_337 }

  subject do
    Meta::RPC::Connection.new host, port
  end


  describe '#new' do
    it 'should have a host' do
      expect(subject.host).to eq host
    end

    it 'should have a port' do
      expect(subject.port).to eq port
    end

    it 'should not be connected' do
      expect(subject.connected?).to be false
    end
  end

  describe '#connect' do
    it 'should open a tcp connection' do
      expect(TCPSocket).to receive(:open).and_return double closed?: false

      subject.connect
    end
  end

  describe '#send' do
    it 'should send tcp data'
    it 'should send a packet size field'
    it 'should send a packet body field'
  end

  describe '#read' do
    context 'when the requested bytes are already in the buffer' do
      it 'should return immediately'
    end
  end

  describe '#read_packet' do
    context 'when a response is never received' do
      it 'should time out'
    end

    context 'when a valid response is received' do
      it 'should read packet_size + 4 bytes from tcp connection'
    end
  end
end
