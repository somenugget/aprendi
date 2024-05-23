class GenerateStudySetTerms < BaseService
  # @param [String] instructions
  # @!method instructions
  input :instructions

  # @param [StudySet] study_set
  # @!method study_set
  input :study_set

  # @return [Array<Term>]
  def call
    chat_response.then do |response|
      Term.transaction { response.map { save_term(_1) } }
    end
  end

  private

  def chat_response
    @chat_response ||= begin
      llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_ACCESS_TOKEN'], default_options: { temperature: 0.3 })

      # TODO: set Sentry breadcrumbs
      Rails.logger.info("Sending prompt: \n#{prompt}")

      chat_response = llm.complete(prompt: prompt)

      output_parser.parse(chat_response.completion).tap do |parsed_response|
        Rails.logger.info("Chat response: \n#{parsed_response}")
      end
    end
  end

  # @param [Hash] response_row
  # @option response_row [String] :term
  # @option response_row [String] :definition
  def save_term(response_row)
    study_set.terms.create!(response_row)
  end

  def prompt
    prompt_template.format(
      'name' => study_set.name,
      'instructions' => instructions,
      'term_lang' => StudyConfig::LANGUAGES[term_lang],
      'definition_lang' => StudyConfig::LANGUAGES[definition_lang],
      'format_instructions' => output_parser.get_format_instructions
    )
  end

  def prompt_template
    Langchain::Prompt::FewShotPromptTemplate.new(
      prefix: 'You are a language study application',
      suffix: 'I want you to generate 20 words for the study set named {name} ' \
              'which targets {term_lang} to {definition_lang} translation. ' \
              'Follow this user\'s instructions: {instructions}' \
              "\n\n{format_instructions}",
      example_prompt: '',
      examples: [],
      input_variables: %w[name instructions term_lang definition_lang format_instructions]
    )
  end

  def json_schema
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
        },
        required: %w[term definition]
      }
    }
  end

  def output_parser
    @output_parser ||= Langchain::OutputParsers::StructuredOutputParser.from_json_schema(json_schema)
  end

  def term_lang
    study_set.study_config.term_lang
  end

  def definition_lang
    study_set.study_config.definition_lang
  end
end
