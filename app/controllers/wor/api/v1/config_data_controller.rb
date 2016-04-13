class Wor::Api::V1::ConfigDataController < Wor::Api::V1::BaseController
  def index
    @post_layouts = Wor.post_layouts
  end
end
