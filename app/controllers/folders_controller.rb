class FoldersController < ApplicationController
  before_action :set_folder, only: %i[ show edit update destroy ]

  # GET /folders
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  def show
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  def create
    @folder = Folder.new(folder_params)

    if @folder.save
      redirect_to @folder, notice: "Folder was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /folders/1
  def update
    if @folder.update(folder_params)
      redirect_to @folder, notice: "Folder was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /folders/1
  def destroy
    @folder.destroy!
    redirect_to folders_url, notice: "Folder was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def folder_params
      params.require(:folder).permit(:user_id, :name)
    end
end
