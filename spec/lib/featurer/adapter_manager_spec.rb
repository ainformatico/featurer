require 'spec_helper'

describe Featurer::AdapterManager do

  describe 'registered adapters' do
    it 'checks the default adapter' do
      expect(Featurer::AdapterManager.adapters).to include(redis: Featurer::RedisAdapter)
    end
  end

  describe 'create new adapters' do
    it 'registers a new adapter' do
      expect(Featurer::AdapterManager).to receive(:add_adapter).and_call_original

      class TestAdapter < Featurer::Adapter
      end

      expect(Featurer::AdapterManager.adapters).to include(test: TestAdapter)
    end
  end
end
