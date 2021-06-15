# frozen_string_literal: true

RSpec.describe Grouper do
  describe '#start' do
    let(:matching_type) { 'phone' }
    let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }

    before do
      allow(File).to receive(:write)
    end

    subject { described_class.start(filename, matching_type) }

    context 'with a valid csv file' do
      it 'successfully runs the program' do
        expect(subject).to eq true
      end
    end

    context 'with an invalid csv file' do
      let(:filename) { 'tmp/input.csv' }
      it 'does not run the program' do
        expect(subject).to eq false
      end
    end
  end
end
