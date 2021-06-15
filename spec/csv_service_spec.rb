# frozen_string_literal: true

RSpec.describe CsvService do
  let(:grouped_contacts) do
    [
      { firstname: 'Josh', lastname: 'Davies', phone: '5555555555', email: 'josh@example.com', zip: '90210', uuid: '1234abcd' },
      { firstname: 'Frank', lastname: 'Davies', phone: '5555555556', email: nil, zip: '90210', uuid: '1234abcde' }
    ]
  end

  let(:filename) { 'tmp/input.csv' }
  let(:group_filename) { 'tmp/input_grouped.csv' }

  describe '#create_csv' do
    subject { described_class.create_csv(filename, grouped_contacts) }
    before { allow(File).to receive(:write) }

    it 'generates the grouped CSV' do
      expected_result = <<~CSV
        firstname,lastname,phone,email,zip,uuid
        Josh,Davies,5555555555,josh@example.com,90210,1234abcd
        Frank,Davies,5555555556,,90210,1234abcde
      CSV
      subject
      expect(File).to have_received(:write).with(group_filename, expected_result)
    end
  end
end
