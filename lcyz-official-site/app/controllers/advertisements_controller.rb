# frozen_string_literal: true
class AdvertisementsController < ApplicationController
  def index
    @advertisements = Advertisement.where(tenant: current_tenant).all
  end

  def show
    @advertisement = Advertisement.where(tenant: current_tenant).find(params[:id])
  end
end
