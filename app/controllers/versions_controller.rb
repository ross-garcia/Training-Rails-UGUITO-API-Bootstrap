class VersionsController < ApplicationController
  def show
    render json: { version: api_version }, status: :ok
  end

  private

  def api_version
    UguitoApi::Application::VERSION
  end
end
