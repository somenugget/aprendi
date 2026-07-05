# frozen_string_literal: true

class UI::AudioButtonComponent < ApplicationComponent
  extend Dry::Initializer

  option :audio
  option :audio_path
  option :label, default: proc { 'Play audio' }

  private

  def render?
    audio.attached?
  end
end
