# frozen_string_literal: true

require 'import'

module Repositories
  class CommentRepo
    include Import['persistence.db']
  end
end
