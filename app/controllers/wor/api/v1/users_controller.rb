class Wor::Api::V1::UsersController < Wor::Api::V1::BaseController

  def index
    if User.respond_to? :wor_users
      @users = User.wor_users
    else
      @users = User.all
    end

    render_message({view: :index})
  end

end
