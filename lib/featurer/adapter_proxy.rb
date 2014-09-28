module Featurer
  class AdapterProxy
    attr_reader :adapter

    def initialize(config = {})
      initialize_adapter(default_options.merge(config))
    end

    private

    def default_options
      # redis adapter is shipped within this gem
      {
        adapter: :redis,
        prefix: :featurer
      }
    end

    def initialize_adapter(config)
      @adapter = AdapterManager.run(config[:adapter], config)
      @adapter.prepare if @adapter.respond_to? :prepare
    end
  end
end
