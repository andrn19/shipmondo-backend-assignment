class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
    render json: @shipments
  end

  def create
    # Assumes that there is at least one account present in the database
    account = Account.first
    shipmondo_service = ShipmondoService.new
    shipment_data = shipmondo_service.create_shipment(shipment_params[:quantity_of_parcel_type])
    @shipment = account.shipments.new(shipment_id: shipment_data[:shipment_id])
    @shipment.packages_attributes = shipment_data[:package_numbers].map { |pkg_no| { package_number: pkg_no } }
    if @shipment.save
      updated_balance = shipmondo_service.get_account_balance
      account.balance.update(balance: updated_balance[:balance])
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
