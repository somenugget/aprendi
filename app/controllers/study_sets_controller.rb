class StudySetsController < ApplicationController
  before_action :set_study_set, only: %i[ show edit update destroy ]

  # GET /study_sets
  def index
    @study_sets = StudySet.all
  end

  # GET /study_sets/1
  def show
  end

  # GET /study_sets/new
  def new
    @study_set = StudySet.new
  end

  # GET /study_sets/1/edit
  def edit
  end

  # POST /study_sets
  def create
    @study_set = StudySet.new(study_set_params)

    if @study_set.save
      redirect_to @study_set, notice: "Study set was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_sets/1
  def update
    if @study_set.update(study_set_params)
      redirect_to @study_set, notice: "Study set was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /study_sets/1
  def destroy
    @study_set.destroy!
    redirect_to study_sets_url, notice: "Study set was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study_set
      @study_set = StudySet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def study_set_params
      params.require(:study_set).permit(:user_id, :folder_id, :name, :term_lang, :definition_lang)
    end
end
