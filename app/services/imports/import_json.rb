module Imports
  class ImportJSON < BaseService
    # @!method study_set
    # @return [StudySet]
    input :study_set, type: StudySet

    # @!method json
    #  @return [Array<Hash>] The JSON to import
    input :json, type: Array

    # Import terms using the JSON
    def call
      validate_input!

      json.each do |json_item|
        term = study_set.terms.create!(term: json_item['word'], definition: json_item['translation'])

        next if json_item['examples'].blank?

        json_item['examples'].each do |example|
          create_term_example!(example, term)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      fail!(error: e.message)
    end

    private

    def create_term_example!(example, term)
      term.term_examples.create!(
        term: term.term,
        definition: term.definition,
        term_example: example['example'],
        definition_example: example['translation'],
        term_lang: study_set.study_config.term_lang,
        definition_lang: study_set.study_config.definition_lang
      )
    end

    def validate_input!
      validate_terms!
      validate_examples!
    end

    def validate_examples!
      fail!(error: 'All examples have to have "example" and "translation" keys') unless json.all? do |item|
        item['examples'].blank? || item['examples'].all? do |example|
          example['example'].present? && item['translation'].present?
        end
      end
    end

    def validate_terms!
      fail!(error: 'All items have to have "word" and "translation" keys') unless json.all? do |item|
        item['word'].present? && item['translation'].present?
      end
    end
  end
end
