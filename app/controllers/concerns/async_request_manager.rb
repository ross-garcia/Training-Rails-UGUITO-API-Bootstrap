module AsyncRequestManager
  extend ActiveSupport::Concern
  include AsyncRequest::ApplicationHelper

  private

  def async_custom_response(job_id)
    render json: { response: job_id, job_id: job_id, url: async_request_url(job_id) },
           status: :accepted
  end

  def async_request_url(job_id)
    # TODO: Review this disable. With the redirection Firefox crashes due to a security issue
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/301
    # async_request.job_url(response).gsub('/async_request', '/api/v1/async_request')
    log_async_request(job_id)
    async_request.job_url(job_id)
  end

  def log_async_request(job_id)
    Rails.logger.info do
      "Async Request with \"job_id\": \"#{job_id}\""
    end
  end
end
