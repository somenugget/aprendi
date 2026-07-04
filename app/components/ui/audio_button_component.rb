# frozen_string_literal: true

class UI::AudioButtonComponent < ApplicationComponent
  extend Dry::Initializer

  option :term

  private

  def render?
    term.term_audio.attached?
  end
end
