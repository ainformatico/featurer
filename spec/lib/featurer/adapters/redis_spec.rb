require 'spec_helper'

describe Featurer::RedisAdapter do
  it 'should create the connection' do
    expect_any_instance_of(Featurer::RedisAdapter).to receive(:prepare)
      .and_call_original

    Featurer.init
    redis_handler = Featurer.adapter.instance_variable_get(:@redis)

    expect(redis_handler).to be_an(Redis)
    expect(redis_handler.ping).to eq('PONG')
  end
end
