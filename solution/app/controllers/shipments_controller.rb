class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
    render json: @shipments
  end

  def create
    account = Account.first
    shipment_data = ShipmondoService.new.create_shipment(shipment_params[:quantity_of_parcel_type])
    @shipment = account.shipmens.new(shipment_id: shipment_data[:shipment_id])
    @shipment.packages_attributes = shipment_data[:package_numbers].map { |pkg_no| { pkg_no: pkg_no } }
    if @shipment.save
      account.balance.update(amount: ShipmondoService.new.account_balance)
      render json: @shipment.to_json(include: :packages), status: :created
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    head :no_content
  end


  private

  def shipment_params
    params.require(:shipment).permit(:quantity_of_parcel_type)
  end

end
