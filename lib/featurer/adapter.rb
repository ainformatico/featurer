module Featurer
  class Adapter
    attr_reader :config

    def self.inherited(klass)
      AdapterManager.add_adapter klass
    end

    def initialize(config = {})
      @config = config
    end

    # Attaches a new matching value to the given feature.
    # If the feature doesn't exist, the adapter should create it automatically.
    # Feature matching_values must be matched in the order they were added.
    #
    # @param _feature the name of the feature as will be used when questioning if the feature is #on?
    # @param _matching_value the value that will be used to match when calling #on?. Valid values are:
    # =>                       - true: it will match any value (ie: the feature enabled globally)
    # =>                       - false: the feature is disabled globally
    # =>                       - integer: matched when calling #on?, if an integer is passed
    # =>                       - regular expression: matched when calling #on?, if regular expression is passed
    def add(_feature, _matching_value)
      raise 'implement an add method'
    end

    # Completely removes a feature from the system.
    # If the feature doesn't exist, the adapter should not fail.
    def delete(_feature)
      raise 'implement a delete method'
    end

    # Returns true if the feature has a matching value attached wich matches the given value.
    #
    # @param _feature the feature name, as provided when calling #add or #register
    # @param _value the value that will be used when matching against the stored matching_value for the given feature
    # @return response depends on the _value provided
    # =>      true if _value is nil and the _feature has a matching_value of true
    # =>      true if _value is an integer and the _feature has that exact integer attached as a matching_value
    # =>      true if _value is a string and the _feature has a matching_value which is a regexp that matches _value
    # =>      false in any other case
    def on?(_feature, _value = nil)
      raise 'implement a on? method'
    end

    # First deletes the given _feature and then creates it again with only the provided _matching_value attached.
    #
    # @param _feature the feature to register
    # @param _matching_value the new matching_value for the feature that replaces any existing matching_value on it
    def register(_feature, _matching_value = true)
      raise 'implement a register? method'
    end
  end
end
