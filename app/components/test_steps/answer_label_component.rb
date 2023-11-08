# frozen_string_literal: true

class TestSteps::AnswerLabelComponent < ApplicationComponent
  attr_reader :term, :label, :result

  def initialize(term:, label:, result: nil)
    @term = term
    @label = label
    @result = result
  end

  def modifier_class
    if result == 'success'
      '!bg-green-50 !border-green-600 !text-green-600'
    elsif result == 'error'
      '!bg-red-100 !border-red-600 !text-red-600'
    else
      ''
    end
  end
end
