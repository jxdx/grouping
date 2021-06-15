# frozen_string_literal: true

require 'byebug'
require 'csv'
require 'securerandom'

# DupCatcher class code that finds duplicates in a CSV
# based on the matching type sent.
# matching_type can be, email, phone, or both.
# When the CSV has multipe email or phone files, all fields must match.
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
