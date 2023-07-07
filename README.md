# TellerApi

Tellers coding assessment.


## Getting Started

1. Clone or download the project to your local machine.

2. Open a terminal and navigate to the project directory.

3. Install the project dependencies by running the following command:

  ```shell
   mix deps.get
  ```

4. Start the Elixir interactive shell
  ```shell
  iex -S mix
  ```


## How to use the application

You will first need to login in order to view account details.

### Login:
You will need to call the login function passing in device_id, username and password like so:
  ```shell
  TellerApi.App.login('<device_id>', '<username>', '<password>')
  ```

Once logged in you can then interact with the application to get the account details.


### Account Balance:
You can get the account balance by running:
  ```shell
  TellerApi.App.account_balance('<acc_id>')
  ```



### Account Transactions:
You can get the account balance by running:
  ```shell
  TellerApi.App.account_transactions('<acc_id>')
  ```


