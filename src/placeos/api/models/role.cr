# Different support driver types.
enum PlaceOS::API::Models::Role
  # Drivers that communicate with devices or services over SSH.
  SSH

  # Drivers that communicate with devices over cleartext TCP or UDP protocols.
  Device

  # Drivers that communicate with devices of services over a HTTP API.
  Service

  # Drivers that provide an internal abstraction layer.
  Logic
end
