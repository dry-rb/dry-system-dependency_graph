# frozen_string_literal: true

require 'dry/events'
require 'dry/monitor/notifications'
require 'dry/system/container'

class App < Dry::System::Container
  use :dependency_graph
  use :monitoring

  configure do |config|
    config.ignored_dependencies = %i[not_registered]
    config.auto_register = %w[lib]
    config.name = :main
  end

  load_paths!('lib')
end

class OtherApp < Dry::System::Container
  use :dependency_graph
  use :monitoring

  configure do |config|
    config.ignored_dependencies = %i[not_registered]
    config.name = :new_one
    config.auto_register = %w[]
  end
end
