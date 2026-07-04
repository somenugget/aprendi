# frozen_string_literal: true

class TestSteps::AnswerLabelComponent < ApplicationComponent
  attr_reader :term, :label, :result, :play_audio

  def initialize(term:, label:, result: nil, play_audio: false)
    @term = term
    @label = label
    @result = result
    @play_audio = play_audio
  end

  private

  def render_audio_button?
    play_audio && term.term_audio.attached?
  end

  def modifier_class
    if result == 'success'
      'bg-green-50! border-green-600! text-green-600!'
    elsif result == 'error'
      'bg-red-100! border-red-600! text-red-600!'
    else
      ''
    end
  end
end
