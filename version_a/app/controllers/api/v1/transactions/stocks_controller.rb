class Api::V1::Transactions::StocksController < Api::V1::BaseController
  def index
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[],
      optional_fields: %i[stockIsins],
    )

    stocks = if params[:stockIsins].present?
               LatestStockPrice::GetCurrentListStockPrices.call(params[:stockIsins])
             else
               LatestStockPrice::GetListAllStockPrices.call
             end

    render status: :created, json: {
      data: stocks,
    }
  end

  def show
    ValidationUtils.validate_params(
      params: params,
      required_fields: %i[stockIsin],
    )

    stock = LatestStockPrice::GetCurrentStockPrice.call(params[:stockIsin])

    render status: :created, json: {
      data: stock,
    }
  end
end
