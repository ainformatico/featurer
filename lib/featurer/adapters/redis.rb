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

    def delete(feature)
      delete_key(feature)
    end

    def key(name)
      "#{@config[:prefix]}:feature:#{name}"
    end

    def on?(feature, user_id = nil)
      if user_id.nil?
        fetch_key(feature)
      else
        fetch_from_set(feature, user_id)
      end
    end

    def register(name, value = true)
      # ensure old key is deleted in order to
      # prevent performing an action in a different
      # redis type: Redis::CommandError
      delete(name)

      if !value.kind_of?(Array)
        save_key(name, value)
      else
        save_set(name, value)
      end
    end

    private

    def delete_key(name)
      @redis.del key(name)
    end

    def save_key(name, value)
      @redis.set key(name), value
    end

    def save_set(name, value)
      @redis.sadd key(name), value
    end

    def fetch_from_set(name, id)
      @redis.sismember(key(name), id)
    end

    def fetch_key(name)
      @redis.get(key(name)) == 'true'
    end
  end
end
