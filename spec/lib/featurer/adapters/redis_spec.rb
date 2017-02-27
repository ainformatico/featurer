# frozen_string_literal: true
require 'spec_helper'

describe Featurer::RedisAdapter do
  let(:redis_handler) { Featurer.adapter.instance_variable_get(:@redis) }

  before { Featurer.init! }

  it 'creates the connection' do
    expect(redis_handler).to be_an(Redis)
    expect(redis_handler.ping).to eq('PONG')
  end

  describe '#on?' do
    context 'when there is an exception' do
      let(:exception) { StandardError.new }
      let(:logger) { double(Logger) }

      before do
        subject.instance_variable_set :@config, logger: logger

        expect(logger).to receive(:warn)
        expect(subject).to receive(:fetch_from_set).and_raise(exception)
      end

      it "doesn't propagate the exception, just logs it" do
        expect(subject.on?(:feature)).to be(false)
      end
    end
  end

  describe '#enabled_features' do
    context 'when there is an exception' do
      let(:exception) { StandardError.new }
      let(:logger) { double(Logger) }

      before do
        subject.instance_variable_set :@config, logger: logger

        expect(logger).to receive(:warn)
        expect(subject).to receive(:all_features).and_raise(exception)
      end

      it "doesn't propagate the exception, just logs it" do
        expect(subject.enabled_features(:feature)).to be(false)
      end
    end
  end

  describe '#prepare' do
    subject { described_class.new(config).prepare }

    context 'a preconfigured client is provided' do
      let(:client) { double(Redis) }
      let(:config) { { client: client } }

      it 'sets the given client as the adapter client' do
        expect(subject).to eq(client)
      end
    end

    context 'the connection details are provided' do
      let(:config) do
        {
          host: 'the_host',
          port: 3425,
          db: 89
        }
      end

      it 'creates a new redis client with the given settings' do
        expect(subject.client.host).to eq(config[:host])
        expect(subject.client.port).to eq(config[:port])
        expect(subject.client.db).to eq(config[:db])
      end
    end
  end
end
