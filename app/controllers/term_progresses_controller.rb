class TermProgressesController < ApplicationController
  before_action :set_term_progress, only: %i[ show edit update destroy ]

  # GET /term_progresses
  def index
    @term_progresses = TermProgress.all
  end

  # GET /term_progresses/1
  def show
  end

  # GET /term_progresses/new
  def new
    @term_progress = TermProgress.new
  end

  # GET /term_progresses/1/edit
  def edit
  end

  # POST /term_progresses
  def create
    @term_progress = TermProgress.new(term_progress_params)

    if @term_progress.save
      redirect_to @term_progress, notice: "Term progress was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /term_progresses/1
  def update
    if @term_progress.update(term_progress_params)
      redirect_to @term_progress, notice: "Term progress was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /term_progresses/1
  def destroy
    @term_progress.destroy!
    redirect_to term_progresses_url, notice: "Term progress was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term_progress
      @term_progress = TermProgress.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def term_progress_params
      params.require(:term_progress).permit(:term_id, :user_id, :learnt, :tests_count, :success_percentage, :next_test_date)
    end
end
