# frozen_string_literal: true

RSpec.describe DupCatcher do
  describe '#start' do
    subject { described_class.start(filename, matching_type ) }

    # Mathcing type is phone
    context 'when the matching_type is phone' do
      let(:matching_type) { 'phone' }
      context 'when the phone is the same on multiple rows' do
        let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }
        it 'sets the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).not_to eq(subject[2][:uuid])
        end
      end

      context 'when the contact has multiple phone records and they all match' do
        let(:filename) { File.join(__dir__, '/fixtures/input2.csv') }
        it 'sets the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).to eq(subject[3][:uuid])
        end
      end

      context 'when the contact has multiple phone records and only 1 matches' do
        let(:filename) { File.join(__dir__, '/fixtures/input2.csv') }
        it 'does not set the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).not_to eq(subject[1][:uuid])
        end
      end

      context 'when the phone records do not match' do
        let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }
        it 'does not set the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).to_not eq(subject[3][:uuid])
        end
      end
    end

    # Matching type is email
    context 'when the matching_type is email' do
      let(:matching_type) { 'email' }
      context 'when the email is the same on multiple rows' do
        let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }
        it 'sets the same uuid' do
          expect(subject[1][:uuid]).not_to be_nil
          expect(subject[1][:uuid]).to eq(subject[6][:uuid])
        end
      end

      context 'when the contact has multiple email records and they all match' do
        let(:filename) { File.join(__dir__, '/fixtures/input2.csv') }
        it 'sets the same uuid' do
          expect(subject[2][:uuid]).not_to be_nil
          expect(subject[2][:uuid]).to eq(subject[3][:uuid])
        end
      end

      context 'when the contact has multiple email records and only 1 matches' do
        let(:filename) { File.join(__dir__, '/fixtures/input2.csv') }
        it 'does not set the same uuid' do
          expect(subject[6][:uuid]).not_to be_nil
          expect(subject[6][:uuid]).not_to eq(subject[7][:uuid])
        end
      end

      context 'when the email records do not match' do
        let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }
        it 'does not set the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).to_not eq(subject[1][:uuid])
        end
      end
    end

    # Matching type is both
    context 'when the matching_type is both' do
      let(:matching_type) { 'both' }
      context 'when all emails and all phones are the same on multiple rows' do
        let(:filename) { File.join(__dir__, '/fixtures/input3.csv') }
        it 'sets the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).to eq(subject[10000][:uuid])
        end
      end

      context 'when both phone numbers are the same but the emails do not match' do
        let(:filename) { File.join(__dir__, '/fixtures/input2.csv') }
        it 'does not set the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).not_to eq(subject[4][:uuid])
        end
      end

      context 'when both emails are the same but the phone nummbers do not match' do
        let(:filename) { File.join(__dir__, '/fixtures/input1.csv') }
        it 'does not set the same uuid' do
          expect(subject[2][:uuid]).not_to be_nil
          expect(subject[2][:uuid]).not_to eq(subject[3][:uuid])
        end
      end
    end
  end
end
