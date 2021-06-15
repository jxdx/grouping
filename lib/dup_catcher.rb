# frozen_string_literal: true

require 'byebug'
require 'csv'
require 'securerandom'

# DupCatcher class code that finds duplicates in a CSV
# based on the matching type sent.
# matching_type can be, email, phone, or both.
# When the CSV has multipe email or phone files, all fields must match.
class DupCatcher
  def self.start(contents, matching_type)
    new(contents, matching_type).start
  end

  def initialize(contents, matching_type)
    @matching_type = matching_type.to_sym
    @store = {}
    @contents = contents
  end

  private_class_method :new

  def start
    @contents.map do |row|
      row[:uuid] = generate_uuid(row)
    end

    @contents
  end

  def generate_uuid(row)
    value = matching_type_verifier(row)
    return SecureRandom.uuid if value.nil? || value.empty?
    return @store[value] if @store[value]

    @store[value] = SecureRandom.uuid
  end

  def matching_type_verifier(row)
    case @matching_type
    when :email
      email_matcher(row)
    when :phone
      phone_number_matcher(row)
    when :both
      email_matcher(row) + phone_number_matcher(row)
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
