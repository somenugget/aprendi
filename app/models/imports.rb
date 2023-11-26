module Imports
  ParsedTerm = Data.define(:term, :definition, :errors) do
    # @!method initialize(term, definition, errors, term:, term:, definition:, errors: {})

    def initialize(term:, definition:, errors: {}) = super
  end
end
