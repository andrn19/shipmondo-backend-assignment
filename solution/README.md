# My solution to the Shipmondo-backend-assignment
Saw this as a good exercise to learn Ruby on Rails.

## How to run the app

## With Docker
1. First create a `.env` file with the following content:
    ```
        SHIPMONDO_BASE_URL=[yourShipmondoBaseUrl] 
        SHIPMONDO_API_USER=[yourShipmondoUser] 
        SHIPMONDO_API_KEY=[yourShipmondoKey]
    ```
2. `docker build -f dev.dockerfile -t [imageName] .`
3. `docker run --env-file .env -p 3000:3000 --rm -d --name [containerName] [imageName]`
4. Open container terminal with `docker exec -it [containerName] /bin/bash`
5. Run a `curl -X POST http://localhost:3000/accounts` to create a new account
6. Check the balance with `curl http://localhost:3000/balances`
7. Run a `curl -X POST http://localhost:3000/shipments -H "Content-Type: application/json" -d '{"shipment": {"quantity_of_parcel_type": 3}}'` to create a new shipment. *quantity_of_parcel_type* can be set to any integer value.
8. Check the updated balance with `curl http://localhost:3000/balances`
9. Check the shipment with `curl http://localhost:3000/shipments`
