class TermsController < ApplicationController
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
    @term = Term.new(term_params)

    if @term.save
      redirect_to @term, notice: 'Term was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /terms/1
  def update
    if @term.update(term_params)
      redirect_to @term, notice: 'Term was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
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
end
