require "httparty"
require "base64"

class ShipmondoService
    include HTTParty
    base_uri "https://app.shipmondo.com/api/public/v3"

    def initialize
        username = ENV["SHIPMONDO_API_USER"]
        password = ENV["SHIPMONDO_API_KEY"]
        encoded_credentials = Base64.strict_encode64("#{username}:#{password}")
        @headers = {
            "Authorization" => "Basic #{encoded_credentials}",
            "Accept" => "application/json",
            "Content-Type" => "application/json"
        }
    end

    def get_account
        response = self.class.get("/account", headers: @headers)
        if response.success?
            account_name = response.parsed_response["name"]
            account_name
        end
    end

    def get_account_balance
        response = self.class.get("/account/balance", headers: @headers)
        if response.success?
            balance = response.parsed_response["amount"]
            currency_code = response.parsed_response["currency_code"]

        { balance: balance, currency_code: currency_code }
        else
            raise "Failed to get Shipmondo account balance: #{response.body}"
        end
    end

    def create_shipment(quantity_of_parcel_type)
        options = {
            headers: @headers,
            body: {
                "test_mode": true,
                "own_agreement": false,
                "label_format": "a4_pdf",
                "product_code": "GLSDK_SD",
                "service_codes": "EMAIL_NT,SMS_NT",
                "reference": "Order 10001",
                "automatic_select_service_point": true,
                "sender": {
                "name": "Min Virksomhed ApS",
                "attention": "Lene Hansen",
                "address1": "Hvilehøjvej 25",
                "address2": nil,
                "zipcode": "5220",
                "city": "Odense SØ",
                "country_code": "DK",
                "email": "info@minvirksomhed.dk",
                "mobile": "70400407"
                },
                    "receiver": {
                    "name": "Lene Hansen",
                    "attention": nil,
                    "address1": "Skibhusvej 52",
                    "address2": nil,
                    "zipcode": "5000",
                    "city": "Odense C",
                    "country_code": "DK",
                    "email": "lene@email.dk",
                    "mobile": "12345678"
                },
                "parcels": [
                    {
                        "quantity": quantity_of_parcel_type,
                        "weight": 1000
                    }
                ]
            }  
        }

        response = self.class.post("/shipments", options)

        if response.success?
            shipment_id = response.parsed_response["id"]
            # The index of the parcels can just be 0
            # as it is hard coded to create a shipment with only one parcel
            # but there the quantity of parcels can be 1 or more
            quantity_of_parcels = response.parsed_response["parcels"][0]["quantity"]
            if quantity_of_parcels < 1
                package_numbers = [ response.parsed_response["parcels"][0]["pkg_no"] ]
            else
                package_numbers = response.parsed_response["parcels"][0]["pkg_nos"]
            end

            { shipment_id: shipment_id, package_numbers: package_numbers }
        else
            raise "Failed to create Shipmondo shipment: #{response.body}"
        end
    end
end