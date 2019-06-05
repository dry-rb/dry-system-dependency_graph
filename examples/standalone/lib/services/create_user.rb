# frozen_string_literal: true

require 'import'

module Services
  class CreateUser
    include Import['repositories.user_repo', rename_dependency: 'services.empty_service']
  end
end
