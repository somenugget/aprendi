class StudySetsController < ApplicationController
  before_action :set_folder
  before_action :set_study_set, only: %i[show edit update destroy]

  # GET /study_sets
  def index
    @study_sets = (@folder || current_user).study_sets.includes(:folder).order(pinned: :desc, created_at: :desc)
  end

  # GET /study_sets/1
  def show; end

  # GET /study_sets/new
  def new
    @study_set = current_user.study_sets.build(folder: @folder)
  end

  # GET /study_sets/1/edit
  def edit; end

  # POST /study_sets
  def create
    StudySet.transaction do
      @study_set = current_user.study_sets.build({ **study_set_params, folder: @folder })
      @study_set.user = current_user
      @study_set.build_study_config(study_config_params)
      @study_set.save
    end

    generate_study_set_terms

    if @study_set.persisted?
      redirect_to [@folder, @study_set].compact, notice: 'Study set was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def import; end

  # PATCH/PUT /study_sets/1
  def update
    if @study_set.update(study_set_params)
      @study_set.study_config.update(study_config_params) if params.key?(:study_config)

      if to_bool(params[:update_card])
        replace_study_set_card(@study_set)
      else
        redirect_to [@folder, @study_set].compact,
                    notice: 'Study set was successfully updated.',
                    status: :see_other

      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /study_sets/1
  def destroy
    @study_set.destroy!
    redirect_to @folder ? folder_path(@folder) : study_sets_path,
                notice: 'Study set was successfully destroyed.', status: :see_other
  end

  private

  def set_folder
    @folder = current_user.folders.find_by(id: params[:folder_id])
  end

  def set_study_set
    @study_set = current_user.study_sets.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def study_set_params
    params.require(:study_set).permit(:name, :pinned)
  end

  def study_config_params
    params.require(:study_config).permit(:term_lang, :definition_lang)
  end

  def generate_study_set_terms
    return if params[:study_set][:instructions].blank?

    GenerateStudySetTerms.call(
      study_set: @study_set,
      instructions: params[:study_set][:instructions]
    )
  end

  def replace_study_set_card(study_set)
    render turbo_stream: turbo_stream.replace(
      dom_id(study_set, 'card'),
      render_to_string(
        StudySets::CardComponent.new(study_set: study_set)
      )
    )
  end
end
