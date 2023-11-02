class TermsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_folder
  before_action :set_study_set
  before_action :set_term, only: %i[show edit update destroy]

  # GET /terms
  def index
    @terms = Term.all
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
  def create
    @term = @study_set.terms.build(term_params.merge(folder_id: @folder.id))

    if @term.save
      new_term = @study_set.terms.build
      render turbo_stream: [
        turbo_stream.append('study-set_terms', partial: 'terms/term_form', locals: { term: @term }),
        turbo_stream.replace(dom_id(new_term, 'form'), partial: 'terms/term_form', locals: { term: new_term })
      ]
    else
      # debugger
      render turbo_stream: turbo_stream.replace('term-form', partial: 'terms/term_form', locals: { term: @term })
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
    redirect_to terms_url, notice: 'Term was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_term
    @term = Term.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def term_params
    params.require(:term).permit(:folder_id, :study_set_id, :term, :definition)
  end

  def set_folder
    @folder = current_user.folders.find(params[:folder_id])
  end

  def set_study_set
    @study_set = @folder.study_sets.find(params[:study_set_id])
  end
end
