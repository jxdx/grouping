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
    if @matching_type == :email || @matching_type == :phone
      trim_phone_number(row[@matching_type])
    elsif @matching_type == :both
      row[:email].to_s + trim_phone_number(row[:phone]).to_s
    else
      nil
    end
  end

  def trim_phone_number(number)
    number.to_s.tr('-() ', '')
  end
end
