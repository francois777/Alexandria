class ApplicationController < ActionController::API
  # include ActionController::MimeResponds

  rescue_from QueryBuilderError, with: :query_builder_error

  protected

  def query_builder_error(error)
    render status: 400, json: {
      error: {
        message: error.message,
        invalid_params: error.invalid_params
      }
    }
  end

  def paginate(scope)
    paginator = Paginator.new(scope, request.query_parameters, current_url)
    response.headers['Link'] = paginator.links
    paginator.paginate
  end

  def current_url
    request.base_url + request.path
  end

end
