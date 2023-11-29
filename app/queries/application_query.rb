# frozen_string_literal: true

class ApplicationQuery
  extend Dry::Initializer

  class << self
    def option_names
      @option_names ||= dry_initializer.options.map(&:target)
    end
  end

  def relation
    self.class.option_names.reduce(scope) { |scope, option| apply_filter(scope, option) }
  end
  alias result relation

  def to_sql
    relation.to_sql.tr('\"', '')
  end

  def inspect
    "#{to_s[0..-2]} #{inspect_variables} query='#{to_sql}'>"
  end

  private

  def scope_class
    @scope_class ||= scope.class.to_s.deconstantize.constantize
  end

  def table
    @table ||= scope_class.arel_table
  end

  def apply_filter(scope, option)
    return scope unless respond_to?("filter_#{option}", true)
    return scope if send(option).nil? || send(option) == ''

    send("filter_#{option}", scope)
  end

  def inspect_variables
    (instance_variables - [:@scope]).filter_map do |var|
      method = var.to_s[1..]
      next if (val = send(method)).blank?

      "#{method}=#{val}"
    end.join(' ')
  end

  delegate :sanitize_sql_like, to: ApplicationRecord
end
