module NormalizeWord
  # removes accents and downcases the word
  # @param word [String]
  # @return [String]
  def self.normalize_word(word)
    I18n.transliterate(word.strip).downcase
  end

  delegate :normalize_word, to: self
end
