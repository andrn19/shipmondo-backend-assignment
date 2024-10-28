require "httparty"
require "base64"

class ShipmondoService
    include HTTParty
    base_uri ENV["SHIPMONDO_BASE_URI"]

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
                "own_agreement": false,
                "label_format": "a4_pdf",
                "product_code": "GLSDK_SD",
                "service_codes": "EMAIL_NT,SMS_NT",
                "reference": "Order 10001",
                "automatic_select_service_point": true,
                "sender": {
                    "name": "Min Virksomhed ApS",
                    "attention": "Andreas Erhardt Nielsen",
                    "address1": "Test 42",
                    "address2": nil,
                    "zipcode": "5000",
                    "city": "Odense SØ",
                    "country_code": "DK",
                    "email": "jc+andreas@shipmondo.com",
                    "mobile": "12345678"
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
            }.to_json
        }

        response = self.class.post("/shipments", options)


        if response.success?
            shipment_id = response.parsed_response["id"]

            package_numbers = response.parsed_response["parcels"].map { |parcel| parcel["pkg_no"] }

            { shipment_id: shipment_id, package_numbers: package_numbers }
        else
            raise "Failed to create Shipmondo shipment: #{response.body}"
        end
    end
end