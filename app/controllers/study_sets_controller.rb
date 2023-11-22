class StudySetsController < ApplicationController
  before_action :set_folder
  before_action :set_study_set, only: %i[show edit update destroy]

  # GET /study_sets
  def index
    @study_sets = StudySet.all
  end

  # GET /study_sets/1
  def show; end

  # GET /study_sets/new
  def new
    @study_set = StudySet.new
  end

  # GET /study_sets/1/edit
  def edit; end

  # POST /study_sets
  def create
    StudySet.transaction do
      @study_set = @folder.study_sets.build(study_set_params)
      @study_set.user = current_user
      @study_set.build_study_config(study_config_params)
      @study_set.save
    end

    if @study_set.persisted?
      redirect_to [@folder, @study_set], notice: 'Study set was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_sets/1
  def update
    if @study_set.update(study_set_params)
      redirect_to folder_study_set_path(@folder, @study_set), notice: 'Study set was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /study_sets/1
  def destroy
    @study_set.destroy!
    redirect_to folder_path(@folder), notice: 'Study set was successfully destroyed.', status: :see_other
  end

  private

  def set_folder
    @folder = current_user.folders.find(params[:folder_id])
  end

  def set_study_set
    @study_set = @folder.study_sets.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def study_set_params
    params.require(:study_set).permit(:name)
  end

  def study_config_params
    params.require(:study_config).permit(:term_lang, :definition_lang)
  end
end
