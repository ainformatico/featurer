# frozen_string_literal: true
require 'spec_helper'

describe Featurer::Facade do
  describe 'configuration' do
    it 'uses default options' do
      Featurer.init!

      expect(Featurer.adapter.config).to include(adapter: :redis)
    end

    context 'when providing a configuration' do
      let(:new_config) do
        {
          adapter: :redis,
          prefix: :custom,
          host: '192.168.1.1'
        }
      end

      it 'configures the adapter' do
        Featurer.configure(new_config)

        expect(Featurer.adapter.config).to include(new_config)
      end
    end

    describe 'supports passing a custom logger in the config' do
      let(:logger) { double(Logger) }

      context 'no logger is passed in the config' do
        before do
          expect(Logger).to receive(:new).with(STDOUT).and_return(logger)
        end

        it 'sets a default logger' do
          Featurer.configure({})

          expect(Featurer.logger).to eq(logger)
        end
      end

      context 'a logger is passed in the config' do
        it 'sets a default logger' do
          Featurer.configure(logger: logger)

          expect(Featurer.logger).to eq(logger)
        end
      end
    end
  end

  describe 'reset configuration' do
    before do
      class NilAdapter < Featurer::Adapter
      end
    end

    describe '#init' do
      it 'resets the adapter' do
        Featurer.configure(adapter: :nil)
        Featurer.init!

        expect(Featurer.config).to include(adapter: :redis)
      end

      it "doesn't reset the adapter" do
        Featurer.configure(adapter: :nil, prefix: :custom)
        Featurer.init

        expect(Featurer.config).to eq(adapter: :nil, prefix: :custom)
      end
    end

    describe '#reset' do
      it 'resets the adapter' do
        Featurer.configure(adapter: :nil)
        Featurer.reset

        expect(Featurer.adapter).to_not be
      end
    end
  end

  describe 'calling methods not defined in the adapter' do
    it 'produces an error' do
      expect { Featurer.this_is_clearly_not_a_valid_method_ok }.to raise_error(NoMethodError)
    end
  end
end
