class TermAudiosController < ApplicationController
  def show
    term = Term.joins(:study_set).find_by(id: params[:term_id], study_sets: { user_id: current_user.id })

    head :not_found and return if term.blank? || !term.term_audio.attached?

    redirect_to rails_blob_path(term.term_audio, disposition: :inline), allow_other_host: false
  end
end
