module Featurer
  class Adapter
    attr_reader :config

    def self.inherited(klass)
      AdapterManager.add_adapter klass
    end

    def initialize(config = {})
      @config = config
    end

    def delete(feature)
      fail 'implement a delete method'
    end

    def key(name)
      fail 'implement a key method'
    end

    def on?(feature, user_id = nil)
      fail 'implement a on? method'
    end

    def register(name, value = true)
      fail 'implement a register? method'
    end
  end
end
