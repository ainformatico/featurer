# frozen_string_literal: true
require 'featurer/adapter_proxy'
require 'featurer/adapter_manager'
require 'featurer/adapter'
require 'featurer/adapters/redis'
require 'featurer/facade'
require 'featurer/version'

module Featurer
  extend Facade
end
