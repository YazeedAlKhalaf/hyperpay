# hyperpay

## 🍎 iOS Setup

### Requirements:

- Xcode 12 and iOS 14 SDK
- iOS 10.0+ deployment target

## 🚨 Error Handling

All our error codes start with `hyperpay-` prefix.
To handle errors you have to catch `PlatformException`.

| Error Code                      | Description                                                                    |
| ------------------------------- | ------------------------------------------------------------------------------ |
| `hyperpay-method-not-found`     | This indicates that the method you invoked through the channel does not exist. |
| `hyperpay-transaction-error`    | This indicates that the transaction has an error.                              |
| `hyperpay-transaction-failure`  | This indicates that the transaction failed for unknown reason.                 |
| `hyperpay-transaction-canceled` | This indicates that the transaction was canceled prematurely.                  |
