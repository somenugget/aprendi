require 'langchain'

class GenerateTermExamples < BaseService # rubocop:disable Metrics/ClassLength
  # @param [Term] term
  # @!method term
  input :term, type: Term

  EXAMPLES_COUNT_TO_GENERATE = 20

  HEADERS = %w[term definition term_lang definition_lang term_example definition_example].freeze

  # @return [Array<TermExample>]
  def call
    return if term.term_examples.count >= EXAMPLES_COUNT_TO_GENERATE

    chat_response.each { save_example(it) }
  end

  private

  def chat_response
    @chat_response ||= begin
      llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_ACCESS_TOKEN'], default_options: { temperature: 0.3 })

      # TODO: set Sentry breadcrumbs
      Rails.logger.info("Sending prompt: \n#{prompt}")

      chat_response = llm.complete(prompt:)

      output_parser.parse(chat_response.completion).tap do |parsed_response|
        Rails.logger.info("Chat response: #{parsed_response}")
      end
    end
  end

  def prompt
    @prompt ||=
      prompt_template.format(
        'term' => term.term,
        'definition' => term.definition,
        'term_lang' => StudyConfig::LANGUAGES[term_lang],
        'definition_lang' => StudyConfig::LANGUAGES[definition_lang],
        'format_instructions' => output_parser.get_format_instructions
      )
  end

  def prompt_template # rubocop:disable Metrics/MethodLength
    Langchain::Prompt::FewShotPromptTemplate.new(
      prefix: 'You are a professional language teacher and lexicographer. ' \
              "Your task is to generate #{EXAMPLES_COUNT_TO_GENERATE} high-quality usage examples for learners. " \
              'Focus on making the examples natural, clear, and pedagogically useful.',
      suffix: 'The target term is "{term}" in {term_lang}, meaning "{definition}" in {definition_lang}. ' \
              "Context: The term belongs to a study set about \"#{term.study_set.name}\". " \
              'Generate examples that are topically relevant to this context when possible. ' \
              "Guidelines:\n" \
              "- Keep the target term exactly as provided (do not conjugate or inflect it).\n" \
              "- Each example sentence must be short, natural, and something a native speaker might actually say.\n" \
              '- Vary the contexts: everyday life, formal, informal, questions, narration. ' \
              "Prioritize those relevant to the study set.\n" \
              "- Provide the corresponding translation in {definition_lang}, ensuring it is accurate and idiomatic.\n" \
              "- Avoid repeating the same sentence structure.\n" \
              "- Return ONLY structured output following this format:\n" \
              '{format_instructions}',
      example_prompt: '',
      examples: [],
      input_variables: %w[term term_lang definition definition_lang format_instructions]
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
