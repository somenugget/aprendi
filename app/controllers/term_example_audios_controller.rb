class TermExampleAudiosController < ApplicationController
  def show
    term_example = TermExample.find_by(id: params[:term_example_id])

    head :not_found and return if term_example.blank?

    head :not_found and return unless owns_term_example?(term_example)

    head :not_found and return unless term_example.term_example_audio.attached?

    redirect_to rails_blob_path(term_example.term_example_audio, disposition: :inline), allow_other_host: false
  end

  private

  def owns_term_example?(term_example)
    term_example.terms.joins(:study_set).exists?(study_sets: { user_id: current_user.id })
  end
end
