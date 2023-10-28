class TestStepsController < ApplicationController
  before_action :set_test_step, only: %i[ show edit update destroy ]

  # GET /test_steps
  def index
    @test_steps = TestStep.all
  end

  # GET /test_steps/1
  def show
  end

  # GET /test_steps/new
  def new
    @test_step = TestStep.new
  end

  # GET /test_steps/1/edit
  def edit
  end

  # POST /test_steps
  def create
    @test_step = TestStep.new(test_step_params)

    if @test_step.save
      redirect_to @test_step, notice: "Test step was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /test_steps/1
  def update
    if @test_step.update(test_step_params)
      redirect_to @test_step, notice: "Test step was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /test_steps/1
  def destroy
    @test_step.destroy!
    redirect_to test_steps_url, notice: "Test step was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_step
      @test_step = TestStep.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def test_step_params
      params.require(:test_step).permit(:test_id, :term_id, :type, :status, :position)
    end
end
