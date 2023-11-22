class UI::CardComponentPreview < Lookbook::Preview
  def default
    render(UI::CardComponent.new) do
      'Default card'
    end
  end

  def link_card
    render(UI::CardComponent.new(as: :a, href: '#')) do
      'Create Study Set'
    end
  end

  # @param variant select { choices: [primary, secondary, danger, warning, success, neutral] }
  def with_variant(variant: :md)
    render(UI::CardComponent.new(variant: variant)) do
      'Create Study Set'
    end
  end
end
