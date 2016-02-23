class Wor::Api::V1::ClassifiersController < Wor::Api::V1::BaseController

  def index
    @classifiers = Wor::Classifier.where(true)
    @classifiers = @classifiers.where("classifier_type=?", params[:classifier_type]) if !params[:classifier_type].blank?

    render_message({view: :index})
  end

end
