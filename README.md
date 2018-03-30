![Codeship Status for semlogr/semlogr-rack](https://codeship.com/projects/dbabb960-15e2-0136-f3e7-6691f5d61ed9/status?branch=master)

# Semlogr integration for Rack

This integration provides some extensions for logging with Rack, currently it provides a request logger
that logs the details about all requests including timing information.

## Installation

To install:

    gem install semlogr-rack

Or if using bundler, add semlogr to your Gemfile:

    gem 'semlogr-rack'

then:

    bundle install

## Getting Started

Create an instance of the logger and configue the RequestLogger middleware.

```ruby
require 'semlogr'
require 'semlogr/rack'

Semlogr.logger = Semlogr.create_logger do |c|
  c.log_at :info

  c.write_to :console
end

...

use Semlogr::Rack::RequestLogger
```

## Development

After cloning the repository run `bundle install` to get up and running, to run the specs just run `rake spec`.

## Contributing

See anything broken or something you would like to improve? feel free to submit an issue or better yet a pull request!
