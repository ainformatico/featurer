require 'redis'

module Featurer
  class RedisAdapter < Adapter
    def prepare
      @redis = ::Redis.new({
        host: @config[:host],
        port: @config[:port],
        db: @config[:db]
      })
    end

    def add(feature, value)
      save_set(feature, value)
    end

    def delete(feature)
      delete_key(feature)
    end

    def on?(feature, value = true)
      fetch_from_set(feature, value)
    end

    def off(feature, value)
      remove_from_set(feature, value)
    end

    def register(feature, value = true)
      # ensure old data is wiped
      delete(feature)
      save_set(feature, value)
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

    def fetch_from_set(name, id)
      return @redis.sismember(key(name), id) unless id.is_a?(String)

      @redis.sscan_each(key(name)) do |stored_value|
        regexp = Regexp.new(stored_value)

        return true if regexp.match(id)
      end

      false
    end

    def remove_from_set(name, id)
      @redis.srem(key(name), id)
    end
  end
end
