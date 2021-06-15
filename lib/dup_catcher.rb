# frozen_string_literal: true
require 'byebug'
require 'csv'
require "securerandom"

class DupCatcher
  def self.start(filename, matching_type)
    new(filename, matching_type).start
  end

  def initialize(filename, matching_type)
    @filename = filename
    @matching_type = matching_type.to_sym
    @store = {}
    @headers = nil
  end

  private_class_method :new

  def start
    csv = CsvService.new(@filename)
    csv.read_csv
    
    csv.csv_contents.map do |row|
      row[:uuid] = generate_uuid(row)
    end
    
    csv.create_csv
  end

  def generate_uuid(row)
    value = matching_type_verifier(row)
    return SecureRandom.uuid if value.nil? || value.empty?
    return @store[value] if @store[value]

    @store[value] = SecureRandom.uuid
  end

  def matching_type_verifier(row)
    if @matching_type == :email
      email_matcher(row)
    elsif @matching_type == :phone
      phone_number_matcher(row)
    elsif @matching_type == :both
      email_matcher(row) + phone_number_matcher(row)
    else
      nil
    end
  end

  # I am making the assumption that all 3 phone numbers must match
  # Otherwise, the person might live in the same household but not be the same person.
  # This can be easily changed if the business decision is that if any of the phone numbers
  # match than it is considered the same person.
  def phone_number_matcher(row)
    trim_phone_number(row[:phone]) + trim_phone_number(row[:phone1]) + trim_phone_number(row[:phone2])
  end

  # I am making the same assumption for emails
  # If all emails don't match they could be in the same family but not the same person.
  def email_matcher(row)
    row[:email].to_s + row[:email1].to_s + row[:email2].to_s
  end

  # Removes '-', '()', '.', ' ' 
  def trim_phone_number(number)
    number.to_s.tr('-(). ', '')
  end
end
