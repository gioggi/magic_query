# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MagicQuery do
  describe '.configure' do
    it 'yields configuration block' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(an_instance_of(MagicQuery::Configuration))
    end

    it 'returns configuration' do
      config = described_class.configure
      expect(config).to be_an_instance_of(MagicQuery::Configuration)
    end
  end

  describe '.configuration' do
    it 'returns a Configuration instance' do
      expect(described_class.configuration).to be_an_instance_of(MagicQuery::Configuration)
    end
  end

  describe '.reset' do
    it 'resets configuration' do
      described_class.configure { |c| c.provider = :claude }
      described_class.reset
      expect(described_class.configuration.provider).to eq(:openai)
    end
  end
end
