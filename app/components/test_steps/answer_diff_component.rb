class TestSteps::AnswerDiffComponent < ApplicationComponent
  attr_reader :correct, :wrong, :diff

  class CorrectLetters < Array; end

  class WrongLetters < Array; end

  # @param [String] correct
  # @param [String] wrong
  def initialize(correct:, wrong:)
    @correct = correct
    @wrong = wrong
    @diff = Diff::LCS.sdiff(correct, wrong)
  end

  # @return [String]
  def call
    content_tag :span do
      if show_diff?
        render_groups(letters_groups)
      else
        correct
      end
    end
  end

  private

  def show_diff?
    (diff || []).count { |d| d.action != '=' } <= correct.length / 2.0
  end

  def render_groups(groups)
    groups.map do |group|
      concat content_tag(:span, group.join, class: group.is_a?(WrongLetters) && 'font-bold')
    end
  end

  def letters_groups
    groups = []
    current_group = CorrectLetters.new

    diff.each do |d|
      if d.action == '=' && current_group.is_a?(WrongLetters)
        groups << current_group
        current_group = CorrectLetters.new
      end

      if d.action != '=' && current_group.is_a?(CorrectLetters)
        groups << current_group
        current_group = WrongLetters.new
      end

      current_group.push d.old_element
    end

    groups << current_group
  end
end
