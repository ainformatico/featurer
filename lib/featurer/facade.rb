# frozen_string_literal: true
require 'logger'

module Featurer
  module Facade
    attr_accessor :adapter, :logger

    def configure(config)
      @adapter = AdapterProxy.new(config).adapter
      @logger = config[:logger] || Logger.new(STDOUT)
    end

    def reset
      @adapter = nil
    end

    def init!
      reset
      init
    end

    def init
      @adapter ||= AdapterProxy.new.adapter
    end

    def method_missing(method, *args)
      if @adapter.respond_to? method
        @adapter.send(method, *args)
      else
        super
      end
    end
  end
end
