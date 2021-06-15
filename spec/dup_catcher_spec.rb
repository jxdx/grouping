# frozen_string_literal: true

RSpec.describe DupCatcher do
  describe '#start' do
    # Contacts is a subset of each input csv file with an added id so it's easy for the next
    # developer to read
    let(:contacts) do
      [
        # input1.csv sample
        { id: '0', firstname: 'John', lastname: 'Smith', phone: '(555) 123-4567', email: 'johns@home.com', zip: '94105' },
        { id: '1', firstname: 'Jane', lastname: 'Smith', phone: '(555) 123-4567', email: 'janes@home.com', zip: '94105-1245' },
        { id: '2', firstname: 'Jack', lastname: 'Smith', phone: '444.123.4567', email: 'jacks@home.com', zip: '94105' },
        # input2.csv sample
        { id: '3', firstname: 'John', lastname: 'Doe', phone1: '(555) 123-4567', phone2: '(555) 987-6543',
          email1: 'jacks@home.com', email2: nil, zip: '94105' },
        { id: '4', firstname: 'Jane', lastname: 'Doe', phone1: '(555) 123-4567', phone2: '(555) 654-9873',
          email1: 'janed@home.com', email2: 'johnd@home.com', zip: '94105' },
        { id: '5', firstname: 'Jack', lastname: 'Doe', phone1: '(444) 123-4567', phone2: '(555) 654-9873',
          email1: 'jackd@home.com', email2: 'johnd@home.com', zip: '94105' },
        { id: '6', firstname: 'John', lastname: 'Doe', phone1: '(555) 123-4567', phone2: '(555) 987-6543',
          email1: 'jackd@home.com', email2: nil, zip: '94105' },
        { id: '7', firstname: 'Jack', lastname: 'Doe', phone1: '(444) 123-4567', phone2: '(555) 654-9873',
          email1: 'jackd@home.com', email2: nil, zip: '94109' },
        { id: '8', firstname: 'John', lastname: 'Doe', phone1: '(555) 123-4567', phone2: '(555) 987-6543',
          email1: 'jackd@home.com', email2: nil, zip: '94105' },
        { id: '9', firstname: 'Josh', lastname: 'Davies', phone1: '(654) 987-1234', phone2: '(654) 987-1234',
          email1: 'josh@home.com', email2: 'josh2@home.com', zip: '94129' },
        { id: '10', firstname: 'Frank', lastname: 'Davies', phone1: '(654) 987-1234', phone2: '(654) 987-1235',
          email1: 'josh@home.com', email2: 'frank@home.com', zip: '94129' },
        # Input3.csv sample
        { id: '11', firstname: 'Vera', lastname: 'Sandoval', phone1: '1-855-404-7690', phone2: '1-414-697-5481',
          email1: 'Aliquam.fringilla@morbi.co.uk', email2: 'non@pellentesque.co.uk', zip: 'E9 8SL' },
        { id: '12', firstname: 'Vera', lastname: 'Sandoval', phone1: '1-855-404-7690', phone2: '1-414-697-5481',
          email1: 'Aliquam.fringilla@morbi.co.uk', email2: 'non@pellentesque.co.uk', zip: 'E9 8SL' }
      ]
    end

    subject { described_class.start(contacts, matching_type) }

    # Mathcing type is phone
    context 'when the matching_type is phone' do
      let(:matching_type) { 'phone' }
      context 'when the phone is the same on multiple rows' do
        it 'sets the same uuid' do
          expect(subject[0][:uuid]).not_to be_nil
          expect(subject[0][:uuid]).to eq(subject[1][:uuid])
          expect(subject[0][:uuid]).not_to eq(subject[2][:uuid])
        end
      end

      context 'when the contact has multiple phone records and they all match' do
        it 'sets the same uuid' do
          expect(subject[3][:uuid]).not_to be_nil
          expect(subject[3][:uuid]).to eq(subject[6][:uuid])
        end
      end

      context 'when the contact has multiple phone records and only 1 matches' do
        it 'does not set the same uuid' do
          expect(subject[3][:uuid]).not_to be_nil
          expect(subject[3][:uuid]).not_to eq(subject[4][:uuid])
        end
      end

      context 'when none of the phone records match' do
        it 'does not set the same uuid' do
          expect(subject[3][:uuid]).not_to be_nil
          expect(subject[3][:uuid]).to_not eq(subject[5][:uuid])
        end
      end
    end

    # Matching type is email
    context 'when the matching_type is email' do
      let(:matching_type) { 'email' }
      context 'when the email is the same on multiple rows' do
        it 'sets the same uuid' do
          expect(subject[7][:uuid]).not_to be_nil
          expect(subject[7][:uuid]).to eq(subject[8][:uuid])
        end
      end

      context 'when the contact has multiple email records and they all match' do
        it 'sets the same uuid' do
          expect(subject[6][:uuid]).not_to be_nil
          expect(subject[6][:uuid]).to eq(subject[7][:uuid])
        end
      end

      context 'when the contact has multiple email records and only 1 matches' do
        it 'does not set the same uuid' do
          expect(subject[9][:uuid]).not_to be_nil
          expect(subject[9][:uuid]).not_to eq(subject[10][:uuid])
        end
      end

      context 'when the email records do not match' do
        it 'does not set the same uuid' do
          expect(subject[4][:uuid]).not_to be_nil
          expect(subject[4][:uuid]).to_not eq(subject[5][:uuid])
        end
      end
    end

    # Matching type is both
    context 'when the matching_type is both' do
      let(:matching_type) { 'both' }
      context 'when all emails and all phones are the same on multiple rows' do
        it 'sets the same uuid' do
          expect(subject[11][:uuid]).not_to be_nil
          expect(subject[11][:uuid]).to eq(subject[12][:uuid])
        end
      end

      context 'when both phone numbers are the same but the emails do not match' do
        it 'does not set the same uuid' do
          expect(subject[5][:uuid]).not_to be_nil
          expect(subject[5][:uuid]).not_to eq(subject[7][:uuid])
        end
      end

      context 'when both emails are the same but the phone nummbers do not match' do
        it 'does not set the same uuid' do
          expect(subject[6][:uuid]).not_to be_nil
          expect(subject[6][:uuid]).not_to eq(subject[7][:uuid])
        end
      end
    end
  end
end
