# frozen_string_literal: true
module Featurer
  class AdapterManager
    class << self
      def add_adapter(klass)
        name = extract_name(klass)
        adapters[name] = klass
      end

      def adapters
        @adapters ||= {}
      end

      def run(name, config)
        adapters
          .fetch(name)
          .new(config)
      end

      private

      def extract_name(klass)
        klass.name
             .downcase[/(?:\w+$)/] # get only class name
             .sub('adapter', '') # remove adapter prefix
             .to_sym
      end
    end
  end
end
