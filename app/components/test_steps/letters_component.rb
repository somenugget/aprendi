# frozen_string_literal: true

class TestSteps::LettersComponent < ApplicationComponent
  attr_reader :test_step

  def initialize(test_step:)
    @test_step = test_step
  end

  private

  def chars
    test_step.term.term.downcase.chars
  end

  def char_to_guess?(char)
    char.match?(/\p{L}/)
  end

  def chars_to_guess
    chars.select { |char| char_to_guess?(char) }
  end
end
