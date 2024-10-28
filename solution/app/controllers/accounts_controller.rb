class AccountsController < ApplicationController
  def show
    account = Account.first
    render json: account
  end

  def create
    account_name = ShipmondoService.new.get_account
    balance_data = ShipmondoService.new.get_account_balance
    @account = Account.new(name: account_name)
    @account.balance = Balance.new(balance: balance_data[:balance], currency: balance_data[:currency_code])

    if @account.save
      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end
end
