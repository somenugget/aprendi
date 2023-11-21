class UI::ButtonComponentPreview < Lookbook::Preview
  # @param variant select { choices: [primary, secondary, danger, warning, success, neutral] }
  def with_variants(variant: :primary)
    render(UI::ButtonComponent.new(variant: variant)) do
      'Create Study Set'
    end
  end

  # @param icon text
  def with_icon(icon: 'magnifying-glass')
    render(UI::ButtonComponent.new(icon: icon)) do
      'Create Study Set'
    end
  end

  # @param size select { choices: [xs, sm, md, lg, xl] }
  def with_sizes(size: :md)
    render(UI::ButtonComponent.new(size: size)) do
      'Create Study Set'
    end
  end

  def link_button
    render(UI::ButtonComponent.new(options: { as: :a, href: '#' })) do
      'Go to page'
    end
  end
end
