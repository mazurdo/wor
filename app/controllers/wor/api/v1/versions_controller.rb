class Wor::Api::V1::VersionsController < Wor::Api::V1::BaseController
  def index
    @versions = Wor::Version.where("item_type=? and item_id=?", "Wor::Post", params[:post_id])

    render_message({view: :index})
  end
end
