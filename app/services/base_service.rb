class BaseService
  module DefaultOutput
    # save service call output to the `output` attribute
    # to not define output variable in every service
    def _call
      self.output = super
    end
  end

  # Essential mechanics
  include(ServiceActor::Core)
  include(ServiceActor::Configurable)
  include(ServiceActor::Attributable)
  include(ServiceActor::Playable)

  # @!attribute output
  #   @return [Any] the result of the service call
  output :output, allow_nil: true, default: -> {}

  include(DefaultOutput)

  # Extra concerns
  include(ServiceActor::Checkable)
  include(ServiceActor::Defaultable)
  include(ServiceActor::Failable)
end
