# frozen_string_literal: true

class TestSteps::LettersComponent < ApplicationComponent
  attr_reader :test_step

  def initialize(test_step:)
    @test_step = test_step
  end

  private

  def words
    test_step.term.term.downcase.split.map(&:chars)
  end

  def chars_to_guess
    test_step.term.chars_to_guess
  end
end
