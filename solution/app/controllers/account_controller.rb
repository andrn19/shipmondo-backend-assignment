class AccountController < ApplicationController
  def show
    account = Account.first
    render json: account
  end

  def create
    account_data = ShipmondoService.new.get_account
    account_balance = ShipmondoService.new.get_account_balance
    @account = Account.new(account_id: account_data[:account_id])
    @account.balance = Balance.new(balance: account_balance[:balance])

    if @account.save
      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end
end
