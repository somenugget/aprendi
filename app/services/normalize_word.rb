module NormalizeWord
  # removes accents and downcases the word
  # @param word [String]
  # @return [String]
  def self.normalize_word(word)
    I18n.transliterate(word.strip).downcase
  end

  # downcases the words except for acronyms (all uppercase)
  # @param word [String]
  # @return [String]
  def self.downcase_preserving_acronyms(word)
    word.strip.squish.split.map { it == it.upcase ? it : it.downcase }.join(' ')
  end

  delegate :normalize_word, :downcase_preserving_acronyms, to: self
end
