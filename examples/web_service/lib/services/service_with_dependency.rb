# frozen_string_literal: true

require 'import'

module Services
  class ServiceWithDependency
    include Import['repositories.user_repo', rename_dependency: 'services.empty_service']

    def call
    end
  end
end
