# frozen_string_literal: true

describe Featurer::Adapter do
  describe '#add' do
    it 'raises an error' do
      expect { subject.add(:feature, :matching_value) }.to raise_error(NotImplementedError)
    end
  end

  describe '#delete' do
    it 'raises an error' do
      expect { subject.delete(:feature) }.to raise_error(NotImplementedError)
    end
  end

  describe '#on?' do
    it 'raises an error' do
      expect { subject.on?(:feature, :value) }.to raise_error(NotImplementedError)
    end
  end

  describe '#register' do
    it 'raises an error' do
      expect { subject.register(:feature, :matching_value) }.to raise_error(NotImplementedError)
    end
  end
end
