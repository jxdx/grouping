# frozen_string_literal: true

RSpec.describe Grouper do
  describe '#start' do
    let(:matching_type) { 'phone' }
    let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }

    subject { described_class.start(filename, matching_type) }

    it 'executes the program' do
      subject
      expect((File.exist? 'spec/fixtures/input1_grouped.csv')).to be
    end
  end
end
