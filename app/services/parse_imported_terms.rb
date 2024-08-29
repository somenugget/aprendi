class ParseImportedTerms < BaseService
  DEFAULT_SEPARATOR = '-'.freeze

  # @!method terms_list
  #   @return [String]
  input :terms_list, type: String

  # @!method separator
  #  @return [String]
  input :separator, type: String

  # @return [Array<Imports::ParsedTerm>]
  def call
    lines = terms_list.split("\n")

    lines.compact_blank.map do |line|
      parts = line.chomp.split(separator_to_use)
      Term.new(term: parts[0]&.strip, definition: parts[1]&.strip).tap(&:valid?)
    end
  end

  private

  def separator_to_use
    separator.present? || separator.include?("\s") ? separator : DEFAULT_SEPARATOR
  end
end
