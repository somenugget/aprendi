class ImportsController < ApplicationController
  before_action :set_study_set, only: %i[show create parse]

  def show; end

  def create
    terms_params.each do |term_params|
      @study_set.terms.create(term_params)
    end

    redirect_to @study_set.folder ? folder_study_set_path(@study_set.folder, @study_set) : study_set_path(@study_set),
                notice: 'Terms imported successfully'
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

  def set_study_set
    @study_set = current_user.study_sets.find(params[:study_set_id])
  end

  def terms_params
    params.permit(terms: %i[term definition]).to_h['terms'].values
  end
end
