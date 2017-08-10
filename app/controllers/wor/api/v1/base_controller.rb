class Wor::Api::V1::BaseController < Wor::BaseController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!
  before_action :authenticate_wor_admin?


  private

  def record_not_found(error)
    render_message({code: :error, messages: [error.message], status: :not_found})
  end

  def render_message(opts={})
    options = {code: :success, messages: [], status: 200, view: "/layouts/api/v1/partials/blank"}.merge!(opts)
    @code     = options[:code]
    @messages = options[:messages]

    render options[:view], layout: 'api/v1/application', :status => options[:status]
  end

  def render_model_error(model)
    render_message({messages: Wor::Api.error_serialize(model.errors), code: :model_error, status: 422})
  end

  def authenticate_wor_admin?
    if !wor_current_user.wor_admin?
      render_message({messages: ["Access denied"], code: :error, status: 403})
    end
  end

  def user_for_paper_trail
    !wor_current_user.nil? ? wor_current_user.id : 0
  end
end