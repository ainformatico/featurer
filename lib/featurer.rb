# frozen_string_literal: true
require 'featurer/adapter_proxy'
require 'featurer/adapter_manager'
require 'featurer/adapter'
require 'featurer/adapters/redis'
require 'featurer/facade'
require 'featurer/version'

module Featurer
  extend Facade

  if const_defined?(:Rails)
    class Engine < ::Rails::Engine
      initializer 'featurer:init_adapter' do
        Featurer.init! unless Featurer.adapter
      end
    end
  end
end
