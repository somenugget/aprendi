# frozen_string_literal: true

class Tests::ResultComponent < ApplicationComponent
  attr_reader :test

  # @param [Test] test
  def initialize(test:)
    @test = test
  end

  private

  def total
    @test.test_steps.count
  end

  def successful
    @test.test_steps.successful.count
  end

  def percentage
    successful.to_f / total * 100
  end

  def result_color
    if percentage >= TermProgress::PERCENTAGE_THRESHOLD[:good]
      'text-lime-500'
    elsif percentage >= TermProgress::PERCENTAGE_THRESHOLD[:medium]
      'text-orange-500'
    else
      'text-red-600'
    end
  end

  def failed_steps
    @test.test_steps.failed
  end

  def failed_terms
    @test.terms.where(id: failed_steps.select(:term_id))
  end
end
