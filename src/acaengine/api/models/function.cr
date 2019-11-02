require "json"

# Invocation information for interaction with an exposed driver behaviour.
struct ACAEngine::API::Models::Function
  include JSON::Serializable

  # The number of parameters that the function accepts.
  @[JSON::Field]
  getter arity : Int32

  # Possible parameter kinds.
  enum ParameterKind
    # Required
    Req

    # Optional
    Opt

    # A capture all for all trailing arguments.
    Rest
  end

  # Parameter information as {kind, name}.
  alias Parameter = Tuple(ParameterKind, String)

  # Parameter information.
  @[JSON::Field]
  getter params : Array(Parameter)
end
