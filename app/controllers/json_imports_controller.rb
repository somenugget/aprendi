class JSONImportsController < ApplicationController
  before_action :set_study_set, only: %i[show create]

  def show; end

  def create
    file_json, file_error = parse_json_file
    string_json, string_error = parse_json_string

    return replace_json_import_form(@study_set, file_error, string_error) if file_error || string_error

    file_import_result = Imports::ImportJSON.result(study_set: @study_set, json: file_json)
    string_import_result = Imports::ImportJSON.result(study_set: @study_set, json: string_json)

    if file_import_result.failure? || string_import_result.failure?
      return replace_json_import_form(@study_set, file_import_result.error, string_import_result.error)
    end

    redirect_to study_set_path(@study_set), notice: 'Imported successfully'
  end

  private

  def parse_json_file
    return [[], nil] if json_import_params[:json_file].blank?

    parse_json(json_import_params[:json_file].read)
  end

  def parse_json_string
    return [[], nil] if json_import_params[:json_string].blank?

    parse_json(json_import_params[:json_string])
  end

  def parse_json(json_string)
    [JSON.parse(json_string), nil]
  rescue JSON::ParserError => e
    [nil, e.message]
  end

  def replace_json_import_form(study_set, file_error, string_error)
    render turbo_stream: turbo_stream.replace(
      'json-import-form',
      render_to_string(
        JSONImports::FormComponent.new(study_set: study_set, file_error: file_error, string_error: string_error)
      )
    )
  end

  def set_study_set
    @study_set = current_user.study_sets.find(params[:study_set_id])
  end

  def json_import_params
    params.permit(:json_string, :json_file)
  end
end
