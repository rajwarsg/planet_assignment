class PlanetController < ApplicationController

  def index
  end

  def get_request
    @@data = FileProcess.type_request(get_request_param[:type])
    # respond_to do |format|
    #   format.html { redirect_to companies_path, notice: 'Company was successfully updated.' }
    #   format.json { render :show, status: :ok, location: @company }
    # end
    redirect_to  show_path
  end

  def show
    @result = @@data
  end

  private
    def get_request_param
      params.permit(:type)
    end
end
