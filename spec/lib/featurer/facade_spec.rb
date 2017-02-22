# frozen_string_literal: true
require 'spec_helper'

describe Featurer::Facade do
  describe 'configuration' do
    it 'uses default options' do
      Featurer.init!
      expect(Featurer.adapter.config).to include(adapter: :redis)
    end

    context 'when providing a configu' do
      let(:new_config) do
        {
          adapter: :redis,
          prefix: :custom,
          host: '192.168.1.1'
        }
      end
      let!(:original_config) { Featurer.adapter && Featurer.adapter.config }

      after do
        Featurer.configure(original_config) if original_config
      end

      it 'configures the adapter' do
        Featurer.configure(new_config)

        expect(Featurer.adapter.config).to include(new_config)
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
