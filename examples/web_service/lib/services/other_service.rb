# frozen_string_literal: true

require 'import'

module Services
  class OtherService
    include Import['services.empty_service', 'repositories.comment_repo', repo: 'repositories.post_repo']
  end
end
