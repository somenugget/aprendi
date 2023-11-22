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

          streams << turbo_stream.replace(dom_id(answer_term, 'answer'),
                                          render_to_string(TestSteps::AnswerLabelComponent.new(term: answer_term,
                                                                                               label: answer_term.term, result: 'success')))
        else
          @test_step.register_failure!

          streams << turbo_stream.replace(
            dom_id(answer_term, 'answer'),
            render_to_string(
              TestSteps::AnswerLabelComponent.new(term: answer_term, label: answer_term.term, result: 'error')
            )
          )
          streams << turbo_stream.replace(
            dom_id(correct_term, 'answer'),
            render_to_string(
              TestSteps::AnswerLabelComponent.new(term: answer_term, label: correct_term.term, result: 'success')
            )
          )
        end
      elsif @test_step.pick_definition?
        answer_term = Term.find(params[:answer_term_id])
        correct_term = @test_step.term

        if correct_term.id == answer_term.id
          @test_step.update!(status: :successful)

          streams << turbo_stream.replace(dom_id(answer_term, 'answer'),
                                          render_to_string(TestSteps::AnswerLabelComponent.new(term: answer_term, label: answer_term.definition,
                                                                                               result: 'success')))
        else
          @test_step.register_failure!

          streams << turbo_stream.replace(dom_id(answer_term, 'answer'),
                                          render_to_string(TestSteps::AnswerLabelComponent.new(term: answer_term, label: answer_term.definition,
                                                                                               result: 'error')))
          streams << turbo_stream.replace(dom_id(correct_term, 'answer'),
                                          render_to_string(TestSteps::AnswerLabelComponent.new(term: answer_term, label: correct_term.definition,
                                                                                               result: 'success')))
        end
      elsif @test_step.letters?
        failed = ActiveModel::Type::Boolean.new.cast(params[:test_step][:failed])

        if failed
          @test_step.register_failure!
        else
          @test_step.update!(status: :successful)
        end
      elsif @test_step.write_term?
        answer_term = params[:test_step][:answer_term]
        result = TestSteps::ValidateWord.result(test_step: @test_step, answer: answer_term)

        if result.success?
          @test_step.update!(status: :successful)

          streams << turbo_stream.replace('write-term', render_to_string(
            TestSteps::WriteTermComponent.new(
              test_step: @test_step,
              answer_term: answer_term,
              result: 'success'
            )
          ))
        else
          @test_step.register_failure!

          streams << turbo_stream.replace('write-term', render_to_string(
            TestSteps::WriteTermComponent.new(
              test_step: @test_step,
              answer_term: answer_term,
              result: 'error'
            )
          ))
        end
      end
    end

    next_step = @test.test_steps.not_finished.where('id > ?', @test_step.id).order(:id).first
    if next_step
      next_step.update(status: :in_progress)

      unless @test_step.exercise.in? %w[pick_term pick_definition write_term]
        return redirect_to test_test_step_path(@test, next_step)
      end

      streams << turbo_stream.update('next_step', render_to_string(
        TestSteps::NextStepComponent.new(test_step: next_step)
      ))
    else
      UpdateTermProgressAfterTestJob.perform_later(@test.id)

      return redirect_to result_test_path(@test)
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
