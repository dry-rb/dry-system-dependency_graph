# frozen_string_literal: true

require 'import'

module Services
  class OtherService
    include Import['services.empty_service', 'repositories.comment_repo', repo: 'repositories.post_repo']

    def call
      comment_repo.first
      empty_service.call
    end
  end
end
