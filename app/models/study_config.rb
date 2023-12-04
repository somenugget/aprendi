class StudyConfig < ApplicationRecord
  belongs_to :configurable, polymorphic: true

  LANGUAGES = {
    'en' => 'English',
    'es' => 'Spanish',
    'fr' => 'French',
    'de' => 'German',
    'it' => 'Italian',
    'pt' => 'Portuguese',
    'uk' => 'Ukrainian',
    'ru' => 'Russian'
  }.freeze
end
