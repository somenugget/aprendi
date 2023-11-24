# frozen_string_literal: true

class TestSteps::WriteTermComponent < ApplicationComponent
  attr_reader :test_step, :answer_term, :result

  def initialize(test_step:, answer_term: nil, result: nil)
    @test_step = test_step
    @answer_term = answer_term
    @result = result
  end

  private

  def error?
    result == 'error'
  end

  def success?
    result == 'success'
  end
end
