# frozen_string_literal: true

require 'import'

module Repositories
  class PostRepo
    include Import['persistence.db']
  end
end
