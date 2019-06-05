# frozen_string_literal: true

require 'import'

class Something
  include Import['repositories.user_repo', rename_dependency: 'services.empty_service']
end
