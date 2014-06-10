class DiscountCodesController < ::ApplicationController
  respond_to :json

  def show
    @code = LivingSocialCode.unclaimed.find_by_code(params[:id])
    respond_to do |format|
      if @code
        format.json { render json: { seats: @code.bucket } }
      else
        format.json { render json: { seats: nil } }
      end
    end
  end
end