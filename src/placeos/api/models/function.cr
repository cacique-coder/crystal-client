require "json"

# Invocation information for interaction with an exposed driver behaviour.
struct PlaceOS::API::Models::Function
  include JSON::Serializable

  # The number of parameters that the function accepts.
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
  getter params : Array(Parameter)
end
