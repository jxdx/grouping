# frozen_string_literal: true

# Grouper module that is the main entry point for the Grouper program.
# It reads the contents of a CSV file using the CsvService module.
# It finds duplicate contacts using the DupCatcher class.
# Finally, it creates a new CSV with UUID added to each row using the CsvService module.
module Grouper
  def self.start(filename, matching_type)
    return false unless File.exist?(filename)

    csv_contents = CsvService.read_csv(filename)

    grouped_contacts = DupCatcher.start(csv_contents, matching_type)

    CsvService.create_csv(filename, grouped_contacts)

    true
  end
end
