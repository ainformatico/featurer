require 'spec_helper'

describe Featurer::Facade do
  describe 'configuration' do
    it 'should use default options' do
      Featurer.init!
      expect(Featurer.adapter.config).to include(adapter: :redis)
    end

    it 'should configure the adapter' do
      options = {
        adapter: :redis,
        prefix: :custom,
        host: '192.168.1.1'
      }
      Featurer.configure(options)
      expect(Featurer.adapter.config).to include(options)
    end
  end

  describe 'reset configuration' do
    before do
      class NilAdapter < Featurer::Adapter
      end
    end

    describe '#init' do
      it 'should reset the adapter' do
        Featurer.configure(adapter: :nil)
        Featurer.init!

        expect(Featurer.config).to include(adapter: :redis)
      end

      it 'should not reset the adapter' do
        Featurer.configure(adapter: :nil, prefix: :custom)
        Featurer.init

        expect(Featurer.config).to eq(adapter: :nil, prefix: :custom)
      end
    end

    describe '#reset' do
      it 'should reset the adapter' do
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
