class UI::CardHeader < ApplicationComponent
  attr_reader :header, :right_header

  def initialize(header:, right_header: '')
    @header = header
    @right_header = right_header
  end
end
