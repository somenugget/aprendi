# frozen_string_literal: true

class TestSteps::PickDefinitionComponent < ApplicationComponent
  attr_reader :test_step

  def initialize(test_step:)
    @test_step = test_step
  end
end
