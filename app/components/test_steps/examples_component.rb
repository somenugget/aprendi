# frozen_string_literal: true

class TestSteps::ExamplesComponent < ApplicationComponent
  attr_reader :term

  def initialize(term:)
    @term = term
  end

  private

  def examples
    term.term_examples.shuffle.take(2)
  end
end
