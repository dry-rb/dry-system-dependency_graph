# frozen_string_literal: true

require 'import'

class ServiceWithDependency
  include Import['user_repo', 'empty_service']
end
