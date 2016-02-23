class Wor::Admin::BaseController < Wor::BaseController
  layout :which_layout

  before_filter :authenticate_user!
  before_filter :authenticate_wor_admin?


  private

  def which_layout
    'admin'
  end

  def authenticate_wor_admin?
    if !wor_current_user.wor_admin?
      render_message({messages: ["Access denied"], code: :error, status: 403})
    end    
  end
end
