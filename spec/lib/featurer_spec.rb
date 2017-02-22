# frozen_string_literal: true
require 'spec_helper'

describe Featurer do
  around do |example|
    begin
      Featurer.init!
      example.run
    ensure
      Featurer.delete(:feature)
    end
  end

  let(:user_id) { 1 }

  context 'globally enabled feature' do
    before do
      Featurer.register :feature, true
    end

    it 'matches on an integer' do
      expect(Featurer.on?(:feature, 1)).to be
    end

    it 'matches on a boolean' do
      expect(Featurer.on?(:feature, true)).to be
    end

    it 'matches on a string' do
      expect(Featurer.on?(:feature, 'admin_client_123')).to be
    end
  end

  context 'feature matching_value is a list of integers' do
    it 'returns true because user is in the list' do
      Featurer.register :feature, [user_id]

      expect(Featurer.on?(:feature, user_id)).to be
    end

    it 'defines the user twice and returns true' do
      Featurer.register :feature, [user_id]
      Featurer.register :feature, [user_id]

      expect(Featurer.on?(:feature, user_id)).to be
    end

    it 'returns false because user is not in the list' do
      Featurer.register :feature, [user_id + 1]

      expect(Featurer.on?(:feature, user_id)).to_not be
    end

    it 'gives priority to global features' do
      Featurer.register :feature, [user_id]
      Featurer.register :feature, true

      expect(Featurer.on?(:feature)).to be
      expect(Featurer.on?(:feature, user_id + 1)).to be
    end

    it 'removes a single user from the feature' do
      Featurer.register :feature, [user_id, user_id + 1]
      Featurer.off :feature, user_id

      expect(Featurer.on?(:feature, user_id)).to_not be
      expect(Featurer.on?(:feature, user_id + 1)).to be
    end

    it 'removes multiple users from the feature' do
      Featurer.register :feature, [user_id, user_id + 1]
      Featurer.off :feature, [user_id, user_id + 1]

      expect(Featurer.on?(:feature, user_id)).to_not be
      expect(Featurer.on?(:feature, user_id + 1)).to_not be
    end

    it 'adds a user to a non-existing feature' do
      Featurer.add :feature, user_id

      expect(Featurer.on?(:feature, user_id)).to be
    end

    it 'adds a single user to a existing feature' do
      Featurer.register :feature, [user_id]
      Featurer.add :feature, user_id + 1

      expect(Featurer.on?(:feature, user_id)).to be
      expect(Featurer.on?(:feature, user_id + 1)).to be
    end

    it 'adda multiple users to a feature' do
      Featurer.register :feature, [user_id]
      Featurer.add :feature, [user_id + 1, user_id + 2]

      expect(Featurer.on?(:feature, user_id)).to be
      expect(Featurer.on?(:feature, user_id + 1)).to be
      expect(Featurer.on?(:feature, user_id + 2)).to be
    end

    it "doesn't match a string" do
      Featurer.register :feature, [user_id]

      expect(Featurer.on?(:feature, user_id.to_s))
    end
  end

  context 'feature matching_value is a regular expressions' do
    it 'matches a matching string' do
      Featurer.register :feature, [/^admin_/]

      expect(Featurer.on?(:feature, 'admin_1234')).to be(true)
    end

    it "doesn't match a non-matching string" do
      Featurer.register :feature, [/^admin_/]

      expect(Featurer.on?(:feature, '_admin_1234')).to be(false)
    end
  end

  context 'feature matching_value is a Boolean' do
    it 'returns true because the feature is enabled(default)' do
      Featurer.register :feature
      expect(Featurer.on?(:feature)).to be
    end

    it 'returns true because the feature is enabled(manually)' do
      Featurer.register :feature, true
      expect(Featurer.on?(:feature)).to be
    end

    it 'returns false because the feature is disabled' do
      Featurer.register :feature, false
      expect(Featurer.on?(:feature)).to_not be
    end

    it 'converts a global feature into a per user one' do
      Featurer.register :feature, true
      Featurer.register :feature, [user_id]

      expect(Featurer.on?(:feature, user_id)).to be
      expect(Featurer.on?(:feature)).to_not be
    end
  end
end
