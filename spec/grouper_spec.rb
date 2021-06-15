# frozen_string_literal: true

RSpec.describe Grouper do
  describe '#start' do
    let(:matching_type) { 'phone' }
    let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }

    before do
      allow(File).to receive(:write)
    end

    subject { described_class.start(filename, matching_type) }

    it 'executes the program' do
      expect(subject).to eq true
    end
  end
end
