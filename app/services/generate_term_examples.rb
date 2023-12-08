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

    chat_response.each { save_example(_1) }
  end

  private

  def chat_response
    @chat_response ||= begin
      llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_ACCESS_TOKEN'])

      # TODO: set Sentry breadcrumbs
      Rails.logger.info("Sending prompt: #{prompt}")

      chat_response = llm.chat(prompt: prompt)

      Rails.logger.info("Chat response: #{chat_response}")

      output_parser.parse(chat_response)
    end
  end

  def prompt
    prompt_template.format(
      'term' => term.term,
      'definition' => term.definition,
      'term_lang' => StudyConfig::LANGUAGES[term_lang],
      'definition_lang' => StudyConfig::LANGUAGES[definition_lang],
      'format_instructions' => output_parser.get_format_instructions
    )
  end

  def prompt_template
    Langchain::Prompt::FewShotPromptTemplate.new(
      prefix: 'Generate 5 usage examples for the term and provide its translation. ',
      suffix: '"{term}" in {term_lang} in meaning "{definition}" in {definition_lang}. ' \
              'Do not conjugate the term, keep it as it is. ' \
              'Translate it into {definition_lang}. ' \
              "\n{format_instructions}",
      example_prompt: '',
      examples: [],
      input_variables: %w[term term_lang definition definition_lang]
    )
  end

  def term_lang
    term.study_set.study_config.term_lang
  end

  def definition_lang
    term.study_set.study_config.definition_lang
  end

  def json_schema # rubocop:disable Metrics/MethodLength
    {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          term: {
            type: 'string'
          },
          definition: {
            type: 'string'
          },
          term_lang: {
            type: 'string'
          },
          definition_lang: {
            type: 'string'
          },
          term_example: {
            type: 'string'
          },
          definition_example: {
            type: 'string'
          }
        },
        required: %w[term definition term_lang definition_lang term_example definition_example]
      }
    }
  end

  def output_parser
    @output_parser ||= Langchain::OutputParsers::StructuredOutputParser.from_json_schema(json_schema)
  end

  def save_example(example_row)
    term.term_examples.create!(
      term: example_row['term'],
      definition: example_row['definition'],
      term_example: example_row['term_example'],
      definition_example: example_row['definition_example'],
      term_lang: lang_code(example_row['term_lang']) || term_lang,
      definition_lang: lang_code(example_row['definition_lang']) || definition_lang
    )
  end

  def lang_code(lang)
    StudyConfig::LANGUAGES.invert.transform_keys(&:downcase)[lang.downcase.squish]
  end
end
