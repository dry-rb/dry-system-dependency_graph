# frozen_string_literal: true

require 'import'

module Repositories
  class UserRepo
    include Import['persistence.db']
  end
end
