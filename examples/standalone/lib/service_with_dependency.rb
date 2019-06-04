# frozen_string_literal: true

require 'import'

class ServiceWithDependency
  include Import['user_repo', rename_dependency: 'empty_service']
end
