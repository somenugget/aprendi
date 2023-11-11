# frozen_string_literal: true

class TestSteps::LettersComponent < ApplicationComponent
  attr_reader :test_step

  def initialize(test_step:)
    @test_step = test_step
  end

  def chars
    test_step.term.term.downcase.chars
  end

  def char_to_guess?(char)
    char.match?(/^[a-zA-Z]+$/)
  end

  def chars_to_guess
    chars.select { |char| char_to_guess?(char) }
  end
end
