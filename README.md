# hyperpay

> this plugin is not official.

This plugin is a wrapper around the official SDK of [HyperPay](https://www.hyperpay.com/).

## 🔥 Features:

- 😌 Easy to setup!
- 🚀 Uses the official SDK under the hood!
- 👾 Ability to create custom UI!
- 🧪 Fully tested!
- 🔋 Batteries included!

## 💻 Server Setup

Follow the official guide to setup the two endpoints:

1.  For getting a `checkoutId`.
2.  For getting the status of a payment using its `checkoutId`.

Official Guide: [https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server)

## 🍎 iOS Setup

This will guide your through the process of implementing the iOS part that is needed to make the plugin function correctly.

> If you face any problems, look at the example app and how it is implemented. 😉

### Requirements:

- Xcode 12 and iOS 14 SDK
- iOS 10.0+ deployment target

### Steps:

1. Register a custom URL scheme:

   1. In Xcode, click on your project in the Project Navigator and navigate to **App Target > Info > URL Types**
   2. Click [+] to **add a new URL type**
   3. Under URL Schemes, **enter your app switch return URL scheme**. This scheme must start with your app's Bundle ID. For example, if the app bundle ID is `com.companyname.appname`, then your URL scheme could be `com.companyname.appname.payments`.
   4. Add scheme URL to a whitelist in your app's Info.plist:

   ```xml
   <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>com.companyname.appname.payments</string>
    </array>
   ```

## 🚨 Error Handling

All our error codes start with `hyperpay-` prefix.
To handle errors you have to catch `PlatformException`.

| Error Code                           | Description                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------ |
| `hyperpay-method-not-found`          | This indicates that the method you invoked through the channel does not exist. |
| `hyperpay-transaction-error`         | This indicates that the transaction has an error.                              |
| `hyperpay-transaction-failure`       | This indicates that the transaction failed for unknown reason.                 |
| `hyperpay-card-payment-params-error` | This indicated that the card payment params has an error.                      |
