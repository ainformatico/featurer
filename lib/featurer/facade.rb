module Featurer
  module Facade
    attr_accessor :adapter

    def configure(config)
      @adapter = AdapterProxy.new(config).adapter
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
