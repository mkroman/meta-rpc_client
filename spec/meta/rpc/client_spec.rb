# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Meta::RPC::Client do
  let(:url) { 'tcp://127.0.0.1:31337' }
  let(:shared_secret) { 'a' * 32 }

  subject { Meta::RPC::Client.new url, shared_secret }

  describe '.new' do
    context 'when a too short shared secret is given' do
      let(:shared_secret) { nil }

      it 'should raise an error' do
        expect { subject }.to raise_error Meta::RPC::SharedSecretError
      end
    end
  end

  describe '#connect' do
    it 'should start a connection' do
      expect_any_instance_of(Meta::RPC::Connection).to receive :connect

      subject.connect
    end
  end

  describe '#call' do
    it 'should send data to the connection' do
      allow(subject).to receive :read_response
      expect_any_instance_of(Meta::RPC::Connection).to receive :send

      subject.call 'test', 'a' => 'b'
    end

    it 'should read the response' do
      allow_any_instance_of(Meta::RPC::Connection).to receive :send
      expect(subject).to receive :read_response

      subject.call 'test', 'a' => 'b'
    end
  end
end
