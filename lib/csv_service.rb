# frozen_string_literal: true
require 'byebug'
require 'csv'
require "securerandom"

class CsvService
  def initialize(filename)
    @filename = filename
    @headers = nil
    @csv_contents = []

    puts 'File does not exist' && exit unless File.exist?(@filename)
  end

  def read_csv
    CSV.foreach(@filename, headers: true, header_converters: :symbol) do |row|
      @headers ||= row.headers
      @csv_contents << row.to_h
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

  def csv_contents
    @csv_contents
  end

  # will overwrite existing file
  def generate_filename
    org_filename = @filename.split(".")
    new_filename = org_filename[0] + '_updated.csv'
  end
end
