class BalancesController < ApplicationController
  before_action :set_balance, only: %i[ show destroy ]

  def index
    @balances = Balance.all
    render json: @balances
  end

  def show
    render json: @balance
  end

  def destroy
    @balance.destroy
    head :no_content
  end

  private

  def set_balance
    @balance = Balance.find(params[:id])
  end

end
