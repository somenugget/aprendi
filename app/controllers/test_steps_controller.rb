class TestStepsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_test
  before_action :set_test_step, only: %i[show edit update destroy]

  # GET /test_steps
  def index
    @test_steps = TestStep.all
  end

  # GET /test_steps/1
  def show; end

  # GET /test_steps/new
  def new
    @test_step = TestStep.new
  end

  # GET /test_steps/1/edit
  def edit; end

  # POST /test_steps
  def create
    @test_step = TestStep.new(test_step_params)

    if @test_step.save
      redirect_to @test_step, notice: 'Test step was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /test_steps/1
  def update
    streams = []

    Test.transaction do
      @test.touch

      if @test_step.pick_term?
        answer_term = Term.find(params[:answer_term_id])
        correct_term = @test_step.term

        if correct_term.id == answer_term.id
          @test_step.update!(status: :successful)

          streams << turbo_stream.replace(dom_id(answer_term, 'answer'), partial: 'test_steps/answer_label', locals: { result: 'success', term: answer_term })
        else
          @test_step.update!(status: :failed)

          streams << turbo_stream.replace(dom_id(answer_term, 'answer'), partial: 'test_steps/answer_label', locals: { result: 'error', term: answer_term })
          streams << turbo_stream.replace(dom_id(correct_term, 'answer'), partial: 'test_steps/answer_label', locals: { result: 'success', term: correct_term })
        end
      end
    end

    next_step = @test.test_steps.pending.where('id > ?', @test_step.id).order(:id).first
    if next_step
      next_step.update(status: :in_progress)
      streams << turbo_stream.update('next_step', partial: 'test_steps/next_step', locals: { test_step: next_step })
    end

    render(turbo_stream: streams)
  end

  # DELETE /test_steps/1
  def destroy
    @test_step.destroy!
    redirect_to test_steps_url, notice: 'Test step was successfully destroyed.', status: :see_other
  end

  private

  def set_test
    @test = current_user.tests.find(params[:test_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_test_step
    @test_step = @test.test_steps.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def test_step_params
    params.require(:test_step).permit(:test_id, :term_id, :type, :status, :position)
  end
end
