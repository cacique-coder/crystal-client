# PlaceOS Crystal SDK

[![GitHub release](https://img.shields.io/github/release/placeos/crystal-client.svg)](https://github.com/placeos/crystal-client/releases)
[![Build Status](https://travis-ci.com/placeos/crystal-client.svg?branch=master)](https://travis-ci.com/placeos/crystal-client)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://placeos.github.io/crystal-client/)

A library for building [crystal](crystal-lang.org/) applications that utilise PlaceOS.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     placeos:
       github: placeos/crystal-client
   ```

2. Run `shards install`

## Usage

### Authentication

- *from environment*

    ```crystal
    require "placeos"

    # Extracts user credentials from PLACEOS_USER, PLACEOS_PASS
    client = PlaceOS::Client.from_environment_user

    # OR... extracts key from PLACEOS_API_KEY
    client = PlaceOS::Client.from_environment_key
    ```

- *with a key*

    ```crystal
    require "placeos"

    key = <some key>
    client = PlaceOS::Client.from_key(key)
    ```

- *explicit authentication*

    ```crystal
    require "placeos"

    user = <some username>
    password = <some password>

    # You can optionally supply a key
    client = PlaceOS::Client.new(user, password)
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
