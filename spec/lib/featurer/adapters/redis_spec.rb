# frozen_string_literal: true
require 'spec_helper'

describe Featurer::RedisAdapter do
  let(:redis_handler) { Featurer.adapter.instance_variable_get(:@redis) }

  before { Featurer.init! }

  it 'creates the connection' do
    expect(redis_handler).to be_an(Redis)
    expect(redis_handler.ping).to eq('PONG')
  end
end
