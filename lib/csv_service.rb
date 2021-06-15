# frozen_string_literal: true

require 'byebug'
require 'csv'
require 'securerandom'

# CsvService code that handles reading and writing CSVs
class CsvService
  attr_reader :csv_contents

  def initialize(filename)
    @filename = filename
    @headers = nil
    @csv_contents = []
  end

  def read_csv
    CSV.foreach(@filename, headers: true, header_converters: :symbol) do |row|
      @headers ||= row.headers
      @csv_contents << row.to_h
    end
  end

  def create_csv
    return puts 'File does not exist' unless File.exist?(@filename)

    CSV.open(generate_filename, 'w') do |csv|
      csv << @headers
      @csv_contents.each do |contact|
        csv << contact.values
      end
    end
  end

  # will overwrite existing file
  def generate_filename
    org_filename = @filename.split('.')
    "#{org_filename[0]}_grouped.csv"
  end
end
