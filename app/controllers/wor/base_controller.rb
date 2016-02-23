class Wor::BaseController < ApplicationController
  include Pundit
  protect_from_forgery

  helper Wor::PathsHelper


  private

  def wor_current_user
    send(Wor.current_user_method) if Wor.current_user_method
  end
  helper_method :wor_current_user

end