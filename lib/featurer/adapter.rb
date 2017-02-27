# frozen_string_literal: true
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
    # =>                     - true: it will match any value (ie: the feature enabled globally)
    # =>                     - false: the feature is disabled globally
    # =>                     - regular expression: matched when calling #on?, if regular expression is passed
    # =>                     - other types: matched literally when calling #on?, based on the #to_s representation
    def add(_feature, _matching_value)
      raise NotImplementedError
    end

    # Completely removes a feature from the system.
    # If the feature doesn't exist, the adapter should not fail.
    def delete(_feature)
      raise NotImplementedError
    end

    # Returns true if the feature has a matching value attached wich matches the given value.
    #
    # @param _feature the feature name, as provided when calling #add or #register
    # @param _value the value that will be used when matching against the stored matching_value for the given feature
    # @return a Boolean that depends on the _value provided
    # =>      - true if _value is nil and the _feature has a matching_value of true
    # =>      - true if _value is an integer and the _feature has that exact integer attached as a matching_value
    # =>      - true if _value is a string and the _feature has a matching_value which is a regexp that matches _value
    # =>      - true if _value is any other type and the _feature has a matching_value which has the same exact #to_s
    # =>        representation
    # =>      - false in any other case
    def on?(_feature, _value = true)
      raise NotImplementedError
    end

    # Returns an array with all the enabled features that match the given value (or just the global ones if no value is
    # provided)
    #
    # @param _value the value that will be used when matching against the stored matching_values
    def enabled_features(_value = true)
      raise NotImplementedError
    end

    # First deletes the given _feature and then creates it again with only the provided _matching_value attached.
    #
    # @param _feature the feature to register
    # @param _matching_value the new matching_value for the feature that replaces any existing matching_value on it
    def register(_feature, _matching_value = true)
      raise NotImplementedError
    end
  end
end
