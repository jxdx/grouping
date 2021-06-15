# frozen_string_literal: true

require 'byebug'
require 'csv'
require 'securerandom'

# Grouper class code that is the main entry point for the Grouper program.
# It reads the contents of a CSV file using the CsvService module.
# It finds duplicate contacts using the DupCatcher class.
# Finally, it creates a new CSV with UUID added to each row using the CsvService module.
class Grouper
  def self.start(filename, matching_type)
    new(filename, matching_type).start
  end

  def initialize(filename, matching_type)
    @filename = filename
    @matching_type = matching_type.to_sym
    @store = {}
  end

  private_class_method :new

  def start
    csv_contents = CsvService.read_csv(@filename)

    grouped_contacts = DupCatcher.start(csv_contents, @matching_type)

    CsvService.create_csv(@filename, grouped_contacts)
  end
end
