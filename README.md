# SmartBank

Dependencies
 * Elixir
 * Phoenix
 * Docker
 * docker-compose

*This app is available on heroku*

```
https://smart-bank.herokuapp.com
```

### Installing

```
1 - git clone https://github.com/drsantos20/smart-bank.git
2 - cd smart-bank
3 - docker-compose build
```

### To run

```
docker-compose up
```

And then the following path will be available on your local environment:

```
localhost:4000/api/v1/signup
```

### Running tests

```
mix test
```

### Available URLS:
```
localhost:4000/api/v1/signup -> POST
localhost:4000/api/v1/signin -> POST
localhost:4000/api/v1/deposit -> POST
localhost:4000/api/v1/withdraw -> POST
localhost:4000/api/v1/transfer -> POST


localhost:4000/api/v1/report -> GET
localhost:4000/api/v1/accounts -> GET
localhost:4000/api/v1/wallet/<wallet_id> -> GET
```


`SmartBank.postman_collection` has all the available endpoints and can be imported on `Postman` 
`dev.postman_environment` is the `localhost` environment to be tested and `heroku.postman_environment` has the heroku address environment 


**POST** `localhost:4000/api/v1/signup`

Parameters Example:
```json
{
  "email": "john_due@gmail.com", 
  "password": "password123",
  "name": "John Due"
}
```
Response
```json
{
  "id": "5eb60246-ede8-4bb4-8c05-9cdb56f170bd",
  "name": "John Due"
}
```
**POST** `localhost:4000/api/v1/signin`

Parameters Example:
```json
{
  "email": "john_due@gmail.com", 
  "password": "password123"
}
```
Response (example)
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTbWFydEJhbmsiLCJleHAiOjE1NzU2MDAzNTQsImlhdCI6MTU3MzE4MTE1NCwiaXNzIjoiU21hcnRCYW5rIiwianRpIjoiM2UzZDZhNWQtZDc1My00YmI2LWIzYmQtNDc4ODU4ZDI4NmYzIiwibmJmIjoxNTczMTgxMTUzLCJzdWIiOiI1YWExYjRmZi02MmNmLTQ5YzQtYTk3My0xOTNhZWQ0MDZhY2YiLCJ0eXAiOiJhY2Nlc3MifQ.71O-COZ1f0u4fOB55Bqfq_0zs978vUg9Hmd8RuIPdWc7W3Zc8tqS_-1R_qXytpFP3lYSmgsW79izYueNrlE9Dg"
}
```
### Deposit (Authenticate)

**POST** `localhost:4000/api/v1/deposit`

Parameters Example:
```json
{
  "amount": 10000
}
```
Response (example)
```json
{
    "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
    "amount": "$100.00",
    "date": "2019-11-08T02:46:00",
    "transaction_id": "8fe995cf-0c27-440c-b65f-d6ecc8d63254",
    "type": "deposit"
}
```

**POST** `localhost:4000/api/v1/withdraw`

Parameters Example:
```json
{
  "amount": 500
}
```
Response (example)
```json
{
    "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
    "amount": "$-5.00",
    "date": "2019-11-08T02:50:36",
    "transaction_id": "299320a0-6c1c-4219-8961-02e5b19f1912",
    "type": "withdraw"
}
```

**POST** `localhost:4000/api/v1/transfer`

Parameters Example:
```json
{
  "account_id": "4eb5752b-08c7-4cee-be14-8bdfa48d1212",
  "amount": 9000
}
```
Response (example)
Success
```json
{
    "transactions": [
        {
            "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
            "amount": "$-90.00",
            "date": "2019-11-08T02:55:22",
            "transaction_id": "51c94348-83a2-4bf3-bfb0-180d19095778",
            "type": "transfer"
        },
        {
            "account_id": "55fb5cf6-206f-4e4e-8fee-c08b2c2f5b41",
            "amount": "$90.00",
            "date": "2019-11-08T02:55:22",
            "transaction_id": "3e59f5fa-08ec-4c50-bbdf-05038f7258c6",
            "type": "transfer"
        }
    ]
}
```
### Errors
1. Insuficient Funds
```json
{
  "errors": {
    "detail": {
      "message": "Transfer not allowed: Insuficient funds"
    }
  }
}
```
2. Account not found
```json
{
  "errors": {
    "detail": {
      "message": "Account not found"
    }
  }
}
```
2. Transfer from another account
```json
{
  "errors": {
    "detail": {
      "message": "You just make transfers from your account"
    }
  }
}
```

**GET** `localhost:4000/api/v1/wallet/:account_id`

Parameters Example:

Without json paramenter

Response (example)
```json
{
  "account_id": "5eb60246-ede8-4bb4-8c05-9cdb56f170bd",
  "wallet": "$500.00"
}
```
Errors
```json
{
  "errors": {
    "detail": {
      "message": "Account not found"
    }
  }
}
```
**GET** `localhost:4000/api/v1/report`

Parameters Example:

Without json paramenter

Response (example)
```json
{
    "month": {
        "08": [
            {
                "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
                "amount": "$1,000.00",
                "date": "2019-11-08T02:10:10",
                "transaction_id": "fe72f9b7-b4f7-41a8-8ba0-94e2b2f097da"
            },
            {
                "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
                "amount": "$100.00",
                "date": "2019-11-08T02:46:00",
                "transaction_id": "8fe995cf-0c27-440c-b65f-d6ecc8d63254"
            }
        ]
    },
    "today": [
        {
            "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
            "amount": "$1,000.00",
            "date": "2019-11-08T02:10:10",
            "transaction_id": "fe72f9b7-b4f7-41a8-8ba0-94e2b2f097da"
        },
        {
            "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
            "amount": "$100.00",
            "date": "2019-11-08T02:46:00",
            "transaction_id": "8fe995cf-0c27-440c-b65f-d6ecc8d63254"
        }
    ],
    "year": {
        "11": {
            "08": [
                {
                    "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
                    "amount": "$1,000.00",
                    "date": "2019-11-08T02:10:10",
                    "transaction_id": "fe72f9b7-b4f7-41a8-8ba0-94e2b2f097da"
                },
                {
                    "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
                    "amount": "$100.00",
                    "date": "2019-11-08T02:46:00",
                    "transaction_id": "8fe995cf-0c27-440c-b65f-d6ecc8d63254"
                }
            ]
        }
    }
}
```


### Author

* **Daniel Santos** - *Trying to keep simple and clean* - [drsantos20](https://github.com/drsantos20)
