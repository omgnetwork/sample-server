class PurchasesController < ApplicationController
  before_action :authenticate_user

  def create
    purchase.user = current_user

    if purchase.save
      purchase.confirm!
      serialize({})
    else
      handle_error(:invalid_parameter)
    end
  end

  private

  def purchase
    @purchase ||= if params[:id]
                    Purchase.find_by!(id: params[:id])
                  else
                    Purchase.new(purchase_params)
                  end
  end

  def purchase_params
    params.permit(:product_id, :idempotency_key)
  end
end
