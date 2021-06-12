# frozen_string_literal: true
require 'byebug'

class Grouper

  def self.start(filename, matching_type)
    new(filename, matching_type).start
  end

  def initialize(filename, matching_type)
    @filename = filename
    @matching_type = matching_type.to_sym
  end

  private_class_method :new

  def start
    contacts = DupCatcher.call(@filename, @matching_type)
  end
end
