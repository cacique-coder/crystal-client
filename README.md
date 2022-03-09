# PlaceOS Crystal SDK

[![GitHub release](https://img.shields.io/github/release/placeos/crystal-client.svg)](https://github.com/placeos/crystal-client/releases)
[![CI](https://github.com/PlaceOS/crystal-client/actions/workflows/ci.yml/badge.svg)](https://github.com/PlaceOS/crystal-client/actions/workflows/ci.yml)

A library for building [crystal](crystal-lang.org/) applications that utilise PlaceOS.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     placeos:
       github: placeos/crystal-client
       version: ~> 1.0
   ```

2. Run `shards install`

## Usage

When initialized via the host environment, the key `PLACE_URI` is expected.

### Authentication

- *from environment*

    ```crystal
    require "placeos"

    # Extracts user credentials from the following environment keys...
    # - PLACE_URI
    # - PLACE_EMAIL
    # - PLACE_PASSWORD
    # - PLACE_AUTH_CLIENT_ID
    # - PLACE_AUTH_SECRET
    client = PlaceOS::Client.from_environment_user
    ```

## Development

Run `crystal spec`

## Contributing

1. [Fork it](https://github.com/placeos/crystal-client/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kim Burgess](https://github.com/kimburgess) - creator and maintainer
- [Caspian Baska](https://github.com/caspiano) - contributor and maintainer
