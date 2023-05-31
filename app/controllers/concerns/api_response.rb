# frozen_string_literal: true

# This is a module that is included in the ApplicationController. It is a way to DRY up the code in
# the controllers.
module ApiResponse
  def self.included(base)
    base.class_eval do
      # pass only permitted Parameters only
      ActionController::Parameters.action_on_unpermitted_parameters = :raise

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :unprocessable_entity
      rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters
    end
  end

  private

  ##
  # It renders a JSON response with a success
  #
  # Args:
  #   message: success message
  #   data: response data
  #   status: The HTTP status code. Defaults to :ok
  def success(message = nil, data = nil, status = :ok)
    render json: { message: message, data: data }, status: status
  end

  ##
  # It renders a JSON response with a error
  #
  # Args:
  #   errors: An array of errors that occurred.
  #   status: HTTP status code
  def error(errors = [], status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  def not_found
    error([I18n.t("error.E0001")])
  end

  ##
  # It takes the exception message and returns a JSON response
  #
  # Args:
  #   exception: The exception object that was raised.
  def unprocessable_entity(exception)
    error(exception.record.errors.full_messages)
  end

  ##
  # It takes the exception message and returns a JSON response with a 400 status code
  #
  # Args:
  #   exception: The exception object that was raised.
  def unpermitted_parameters(exception)
    error([exception.message], :bad_request)
  end

  ##
  # It creates a response object from a service object
  #
  # Args:
  #   obj: Response service object to identify error or success.
  #   status: The HTTP status code.
  def service_response(obj)
    if obj.is_success
      success(obj.message, obj.data)
    else
      error(obj.errors)
    end
  end
end
