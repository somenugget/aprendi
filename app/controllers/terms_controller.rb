class TermsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_study_set
  before_action :set_term, only: %i[show edit update destroy]

  # GET /terms
  def index
    @terms = study_set.terms
  end

  # GET /terms/1
  def show; end

  # GET /terms/new
  def new
    @term = Term.new
  end

  # GET /terms/1/edit
  def edit; end

  # POST /terms
  def create # rubocop:disable Metrics/AbcSize
    @term = @study_set.terms.build(term_params)

    if @term.save
      GenerateTermExamplesJob.set(wait: 2.minutes).perform_later(@term.id)

      new_term = @study_set.terms.build
      render turbo_stream: [
        turbo_stream.append('study-set_terms', partial: 'terms/term_form', locals: { term: @term }),
        turbo_stream.replace(
          dom_id(new_term, 'form'),
          partial: 'terms/term_form', locals: { term: new_term, autofocus: true }
        )
      ]
    else
      render turbo_stream: turbo_stream.replace('form_term', partial: 'terms/term_form', locals: { term: @term })
    end
  end

  # PATCH/PUT /terms/1
  def update
    @term.update(term_params)

    render turbo_stream: [
      turbo_stream.replace(dom_id(@term, 'form'), partial: 'terms/term_form', locals: { term: @term })
    ]
  end

  # DELETE /terms/1
  def destroy
    @term.destroy!

    render turbo_stream: [
      turbo_stream.remove(dom_id(@term, 'form'))
    ]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_term
    @term = Term.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def term_params
    params.require(:term).permit(:study_set_id, :term, :definition)
  end

  def set_study_set
    @study_set = current_user.study_sets.find(params[:study_set_id])
  end
end
