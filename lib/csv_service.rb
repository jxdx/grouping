# frozen_string_literal: true

require 'byebug'
require 'csv'
require 'securerandom'

# CsvService code that handles reading and writing CSVs
module CsvService
  def self.read_csv(filename)
    csv_contents = []
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      csv_contents << row.to_h
    end
    csv_contents
  end

  def self.create_csv(filename, csv_contents)
    content = CSV.generate(headers: true) do |csv|
      csv << csv_contents[0].keys
      csv_contents.each do |contact|
        csv << contact.values
      end
    end
    File.write(generate_filename(filename), content)
  end

  # will overwrite existing file
  def self.generate_filename(filename)
    org_filename = filename.split('.')
    "#{org_filename[0]}_grouped.csv"
  end
end
