# frozen_string_literal: true
class Admin::TransferHistoriesController < Admin::ApplicationController
  def index
    @histories = TransferHistory.where(car_id: params[:car_id]).order(transfer_at: :asc)
  end

  def new
    @history = TransferHistory.new
  end

  def create
    TransferHistory.create(transfer_historiy_params)

    redirect_to "/admin/cars/#{params[:car_id]}/transfer_histories"
  end

  def update
    @history = TransferHistory.find(params[:id])
    @history.update_attributes(transfer_historiy_params)

    redirect_to "/admin/cars/#{params[:car_id]}/transfer_histories"
  end

  def destroy
    history = TransferHistory.find(params[:id])
    history.destroy

    redirect_to "/admin/cars/#{params[:car_id]}/transfer_histories"
  end

  private

  def transfer_historiy_params
    params.require(:transfer_history)
          .permit(:car_id, :transfer_type, :transfer_at, :home_location, :description)
  end
end
