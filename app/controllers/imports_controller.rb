class ImportsController < ApplicationController
  before_action :set_folder
  before_action :set_study_set, only: %i[show create parse]

  def show; end

  def create
    terms_params.each do |term_params|
      @study_set.terms.create(term_params.merge(folder: @folder))
    end

    redirect_to folder_study_set_path(@folder, @study_set), notice: 'Terms imported successfully'
  end

  def parse
    result = ParseImportedTerms.call(
      terms_list: params[:terms_list],
      separator: params[:separator]
    )

    render turbo_stream: turbo_stream.replace(
      'parsed-terms',
      render_to_string(
        Imports::ParsedTermsComponent.new(@study_set, result.output)
      )
    )
  end

  private

  def set_folder
    @folder = current_user.folders.find(params[:folder_id])
  end

  def set_study_set
    @study_set = @folder.study_sets.find(params[:study_set_id])
  end

  def terms_params
    params.permit(terms: %i[term definition]).to_h['terms'].values
  end
end
