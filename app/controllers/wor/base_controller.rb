class Wor::BaseController < ApplicationController
  include Pundit::Authorization
  protect_from_forgery

  helper Wor::PathsHelper


  private

  def render_404
    respond_to do |format| 
      format.html {render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found}
      format.json {render :json => "page not found", :status => :not_found}
    end
  end

  def wor_current_user
    send(Wor::Engine.current_user_method) if Wor::Engine.current_user_method
  end
  helper_method :wor_current_user

end