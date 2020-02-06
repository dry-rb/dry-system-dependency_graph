[![Build Status](https://travis-ci.com/dry-rb/dry-system-dependency_graph.svg?branch=master)](https://travis-ci.com/dry-rb/dry-system-dependency_graph)

# Dry::System::DependencyGraph

```ruby
# in container
require 'dry/system/container'

class App < Dry::System::Container
  use :dependency_graph
  use :monitoring

  configure do |config|
    config.ignored_dependencies = %i[not_registered]
  end
end
```

```ruby
# in booting
require 'dry/system/dependency_graph'

# call it before register all dependencies
Dry::System::DependencyGraph.register!(App)
```

Enable realtime checks by this code:
```ruby
# in booting
require 'dry/system/dependency_graph'

Dry::System::DependencyGraph.register!(App)

App.finalize!(freeze: false)
App[:dependency_graph].enable_realtime_calls!
App.freeze
```

Rack based interface
```ruby
require 'dry/system/dependency_graph/web'
Dry::System::DependencyGraph::Web.set :container, App

run Rack::URLMap.new(
  '/' => WebApp.new,
  '/dependency_graph' => Dry::System::DependencyGraph::Web.new(container: App)
)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry-system-dependency_graph'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dry-system-dependency_graph

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dry-system-dependency_graph. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dry::System::DependencyGraph project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dry-system-dependency_graph/blob/master/CODE_OF_CONDUCT.md).
