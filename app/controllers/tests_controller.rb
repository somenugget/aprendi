class TestsController < ApplicationController
  before_action :set_test, only: %i[show edit destroy]

  # GET /tests
  def index
    @tests = Test.all
  end

  # GET /tests/1
  def show; end

  # GET /tests/new
  def new
    @test = Test.new
  end

  # GET /tests/1/edit
  def edit; end

  # POST /tests
  def create
    return redirect_back fallback_location: root_path, alert: 'Study set not found.' if params[:study_set_id].blank?

    @test = Test.create_from_study_set(StudySet.find(params[:study_set_id]), current_user)

    if @test.save
      redirect_to test_test_step_path(@test, @test.test_steps.order(:id).first),
                  notice: 'Test was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /tests/1
  def destroy
    @test.destroy!
    redirect_to tests_url, notice: 'Test was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_test
    @test = current_user.tests.find(params[:id])
  end
end
