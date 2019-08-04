# frozen_string_literal: true

require 'import'

module Repositories
  class CommentRepo
    include Import['persistence.db']

    def first
      db.inspect
    end
  end
end
