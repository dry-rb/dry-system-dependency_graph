# frozen_string_literal: true

require 'import'

module Services
  class CreateUser
    include Import['persistance.users', 'repositories.user_repo', rename_dependency: 'services.empty_service']

    def call
    end
  end
end
