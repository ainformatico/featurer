# frozen_string_literal: true
require 'redis'

module Featurer
  class RedisAdapter < Adapter
    def prepare
      @redis = @config[:client] || ::Redis.new(host: @config[:host],
                                               port: @config[:port],
                                               db: @config[:db])
    end

    def add(feature, value)
      save_set(feature, value)
    end

    def delete(feature)
      delete_key(feature)
    end

    def on?(feature, value = true)
      fetch_from_set(feature, value)
    rescue => e
      @config[:logger].warn e
      false
    end

    def enabled_features(value = true)
      all_features.select { |feature| on?(feature, value) }
    rescue => e
      @config[:logger].warn e
      []
    end

    def off(feature, value)
      remove_from_set(feature, value)
    end

    def register(feature, value = true)
      # ensure old data is wiped
      delete(feature)
      save_set(feature, value)
    end

    def feature_list
      full_feature_names.map do |full_feature_name|
        {
          name: short_feature_name(full_feature_name),
          matching_values: @redis.smembers(full_feature_name)
        }
      end
    end

    private

    def key(name)
      "#{@config[:prefix]}:feature:#{name}"
    end

    def delete_key(name)
      @redis.del key(name)
    end

    def save_set(name, value)
      @redis.sadd key(name), value
    end

    def fetch_from_set(name, value)
      matching_values = @redis.smembers(key(name))

      matching_values.each do |matching_value|
        return true if matching_value == 'true' # Globally enabled feature

        if value.is_a?(String) && matching_value =~ /\(\?-mix:.+\)/ # Regexp matching
          return true if Regexp.new(matching_value).match(value)
        elsif matching_value == value.to_s # By exact value
          return true
        end
      end

      false
    end

    def remove_from_set(name, id)
      @redis.srem(key(name), id)
    end

    def all_features
      full_feature_names.map do |key|
        short_feature_name(key)
      end
    end

    def full_feature_names
      @redis.keys("#{@config[:prefix]}:feature:*")
    end

    def short_feature_name(full_feature_name)
      full_feature_name.split("#{@config[:prefix]}:feature:").last.to_sym
    end
  end
end
