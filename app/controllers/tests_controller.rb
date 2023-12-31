class TestsController < ApplicationController
  before_action :set_test, only: %i[show result edit destroy]

  # GET /tests
  def index
    @tests = current_user.tests
  end

  # GET /tests/1
  def show; end

  def result
    @total = @test.test_steps.count
    @successful = @test.test_steps.successful.count
    @percentage = @successful.to_f / @total * 100
  end

  # GET /tests/new
  def new
    @test = current_user.tests.build
  end

  # GET /tests/1/edit
  def edit; end

  # POST /tests
  def create # rubocop:disable Metrics/AbcSize
    # TODO: show flash message instead

    if params[:study_set_id].present?
      @test = Test.create_from_study_set!(StudySet.find(params[:study_set_id]), current_user)
    elsif params[:terms_ids].present?
      @test = Test.create_from_terms_ids!(params[:terms_ids].to_a, current_user)
    else
      return redirect_back fallback_location: root_path, alert: 'Can\'t create a test'
    end

    first_step = @test.test_steps.order(:id).first.tap do |step|
      step.update!(status: :in_progress)
    end

    redirect_to test_test_step_path(@test, first_step), notice: 'Test was successfully created.'
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
