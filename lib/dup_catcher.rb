# frozen_string_literal: true
require 'byebug'
require 'csv'
require "securerandom"

class DupCatcher
  def self.call(filename, matching_type)
    new(filename, matching_type).call
  end

  def initialize(filename, matching_type)
    @filename = filename
    @matching_type = matching_type.to_sym
    @store = {}
    @headers = nil
    @csv_contents = []
  end

  private_class_method :new

  def call
    read_csv
    
    create_csv
  end

  def read_csv
    CSV.foreach(@filename, headers: true, header_converters: :symbol) do |row|
      @headers ||= row.headers
      @csv_contents << row.to_h
    end
    
    @csv_contents.map do |row|
      row[:uuid] = generate_uuid(row)
    end
  end

  def create_csv
    CSV.open(generate_filename, "w") do |csv|
      csv << @headers
      @csv_contents.each do |contact|
        csv << contact.values
      end
    end
  end

  def generate_uuid(row)
    value = matching_type_verifier(row)
    return SecureRandom.uuid if value.nil? || value.empty?
    return @store[value] if @store[value]

    @store[value] = SecureRandom.uuid
  end
  
  def generate_filename
    org_filename = @filename.split(".")
    new_filename = org_filename[0] + '_updated.csv'
    # File.exist?(new_filename)
  end

  def matching_type_verifier(row)
    if @matching_type == :email || @matching_type == :phone
      row[@matching_type]
    elsif @matching_type == :both
      row[:email].to_s + row[:phone].to_s
    else
      nil
    end
  end
end
