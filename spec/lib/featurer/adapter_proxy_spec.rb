require 'spec_helper'

describe Featurer::AdapterProxy do

  describe 'default adapter' do
    it 'creates the default adapter' do
      proxy = Featurer::AdapterProxy.new
      expect(proxy.adapter).to be_an(Featurer::RedisAdapter)
    end

    it 'creates a new adapter' do
      class TestAdapter < Featurer::Adapter
      end

      proxy = Featurer::AdapterProxy.new(adapter: :test)
      expect(proxy.adapter).to be_an(TestAdapter)
    end
  end
end
