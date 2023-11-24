class StudyConfigsController < ApplicationController
  before_action :set_study_config, only: %i[show edit update destroy]

  # GET /study_configs
  def index
    @study_configs = StudyConfig.all
  end

  # GET /study_configs/1
  def show; end

  # GET /study_configs/new
  def new
    @study_config = StudyConfig.new
  end

  # GET /study_configs/1/edit
  def edit; end

  # POST /study_configs
  def create
    @study_config = StudyConfig.new(study_config_params)

    if @study_config.save
      redirect_to @study_config, notice: 'Study config was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_configs/1
  def update
    if @study_config.update(study_config_params)
      redirect_to @study_config, notice: 'Study config was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /study_configs/1
  def destroy
    @study_config.destroy!
    redirect_to study_configs_url, notice: 'Study config was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_study_config
    @study_config = StudyConfig.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def study_config_params
    params.require(:study_config).permit(:configurable_id, :configurable_type, :term_lang, :definition_lang)
  end
end
