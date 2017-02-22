# frozen_string_literal: true
require 'spec_helper'

describe Featurer::AdapterProxy do
  describe 'default adapter' do
    it 'creates the default adapter' do
      proxy = Featurer::AdapterProxy.new
      expect(proxy.adapter).to be_an(Featurer::RedisAdapter)
    end

    it 'creates a new adapter' do
      class ProxyAdapter < Featurer::Adapter
      end

      proxy = Featurer::AdapterProxy.new(adapter: :proxy)
      expect(proxy.adapter).to be_an(ProxyAdapter)
    end
  end
end
