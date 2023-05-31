# frozen_string_literal: true

# common service for response
class Response

  # identify flag for success or error
  attr_accessor :is_success

  # response data
  attr_accessor :data

  # response success message
  attr_accessor :message

  # list of error message
  attr_accessor :errors

  def initialize
    @errors = []
    @is_success = true
  end
end
