require 'langchain'
require 'csv'

class GenerateTermExamples < BaseService
  # @param [Term] term
  # @!method term
  input :term, type: Term

  HEADERS = %w[term definition term_lang definition_lang term_example definition_example].freeze

  # @return [Array<TermExample>]
  def call
    return if term.long_phrase?
    return if term.term_examples.count > 3

    CSV.parse(chat_response, headers: HEADERS).map do |example_row|
      save_example(example_row)
    end
  end

  private

  def chat_response
    @chat_response ||= begin
      llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_ACCESS_TOKEN'])

      # TODO: set Sentry breadcrumbs
      Rails.logger.info("Sending prompt: #{prompt}")

      chat_response = llm.chat(prompt: prompt)

      # avoid "Illegal quoting in line (CSV::MalformedCSVError)" because of the space before quotes
      chat_response = chat_response.gsub(', "', ',"')

      Rails.logger.info("Chat response: #{chat_response}")

      chat_response
    end
  end

  def prompt # rubocop:disable Metrics/MethodLength
    prompt = Langchain::Prompt::FewShotPromptTemplate.new(
      prefix: 'Generate 5 usage examples for the term and provide its translation.',
      suffix: '"{term}" in {term_lang} in meaning "{definition}" in {definition_lang}. ' \
              'Do not conjugate the term, keep it as it is.' \
              'Translate it into {definition_lang}. ' \
              'Return output as an csv with such columns: ' \
              'term, definition, term_lang, definition_lang, term_example, definition_example.',
      example_prompt: '',
      examples: [],
      input_variables: %w[term term_lang definition definition_lang]
    )

    prompt.format(
      'term' => term.term,
      'definition' => term.definition,
      'term_lang' => StudyConfig::LANGUAGES[term.study_set.study_config.term_lang],
      'definition_lang' => StudyConfig::LANGUAGES[term.study_set.study_config.definition_lang]
    )
  end

  def save_example(example_row)
    # skip if it's a headers row
    return if %w[term definition].all? { |key| example_row[key].downcase.squish == key }

    term.term_examples.create!(
      term: example_row['term'],
      definition: example_row['definition'],
      term_example: example_row['term_example'],
      definition_example: example_row['definition_example'],
      term_lang: lang_code(example_row['term_lang']),
      definition_lang: lang_code(example_row['definition_lang'])
    )
  end

  def lang_code(lang)
    StudyConfig::LANGUAGES.invert.transform_keys(&:downcase)[lang.downcase.squish]
  end
end
