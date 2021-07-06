import Flutter
import UIKit

public class SwiftHyperpayPlugin: NSObject, FlutterPlugin, OPPCheckoutProviderDelegate {
    
    // data from flutter variables.
    var checkoutId:String = "";
    var shopperResultURL:String = ""
    
    // platform channel variables.
    var hyperpayMethodCall:FlutterMethodCall!;
    var hyperpayResult:FlutterResult!;
    
    // hyperpay sdk variables.
    var checkoutProvider:OPPCheckoutProvider!;
    var paymentProviderMode:OPPProviderMode = OPPProviderMode.test;
    var paymentProvider:OPPPaymentProvider!;
    var checkoutSettings:OPPCheckoutSettings = OPPCheckoutSettings();
    
    // misc variables.
    var receivePaymentAsyncronouslyNotificationName:Notification.Name = Notification.Name(
        rawValue: "AsyncPaymentCompletedNotificationKey"
    );
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "hyperpay",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftHyperpayPlugin()
        registrar.addMethodCallDelegate(
            instance,
            channel: channel
        )
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // set the `call` to `hyperpayMethodCall` so it is accessible in the whole class.
        self.hyperpayMethodCall = call;
        // set the `result` to `hyperpayResult` so it is accessible in the whole class.
        self.hyperpayResult = result;
        
        // "getHyperpayResponse" method.
        if (hyperpayMethodCall.method == "getHyperpayResponse") {
            getHyperpayResponse();
            return;
        }
        
        // throws a `PlatformException` because no method with provided name exists.
        self.hyperpayResult(
            FlutterError(
                code: "hyperpay-method-not-found",
                message: "Method name not found.",
                details: "If you think this is a bug, please file an issue in the GitHub repository: https://github.com/YazeedAlKhalaf/hyperpay."
            )
        );
        
    }
    
    /// initialize `checkoutSettings` by setting up from values.
    private func intializeCheckoutSettings() {
        
        // setup `checkoutProvider`
        self.checkoutProvider = OPPCheckoutProvider(
            paymentProvider: self.paymentProvider,
            checkoutID: self.checkoutId,
            settings: self.checkoutSettings
        )!;
        
        // setup `paymentProvider`
        self.paymentProvider = OPPPaymentProvider(
            mode: self.paymentProviderMode
        );
        
        // setup `checkoutSettings`
        checkoutSettings.displayTotalAmount = true
    }
    
    /// initializes the variables of the class from the arguments provided by `hyperpayMethodCall`.
    private func initializeArgumentsFromHyperpayMethodCall() {
        // get arguments from call and unwraps them.
        let arguments = hyperpayMethodCall.arguments as? Dictionary<String, Any>;
        
        // set `paymentProviderMode` based on `mode`.
        // defaults to test, in case the mode is "LIVE", we change it to live mode.
        let mode = (arguments!["mode"] as? String)!;
        if (mode == "LIVE") {
            self.paymentProviderMode = OPPProviderMode.live;
        }
        
        // set `checkoutId` in the class to the value coming from the arguments.
        self.checkoutId = (arguments!["checkoutId"] as? String)!;
        
        // set `shopperResultURL` in the class to the value coming from the arguments.
        // the `shopperResultURL` is used for coming back the app after verifying with the bank.
        self.shopperResultURL = (arguments!["shopperResultURL"] as? String)!
    }
    
    private func getHyperpayResponse() {
        // runs the initialization code for arguments from `hyperpayMethodCall`.
        initializeArgumentsFromHyperpayMethodCall();
        
        // runs the initialization code for starting a payment.
        intializeCheckoutSettings();
        
        // shows the ready UI.
        DispatchQueue.main.async {
            self.openReadyUI();
        }
    }
    
    
    
    private func openReadyUI() {
        // open the payment page
        checkoutProvider.presentCheckout(
            forSubmittingTransactionCompletionHandler: { (transaction, error) in
                guard let transaction = transaction else {
                    // this means the transaction has an error.
                    self.hyperpayResult(
                        FlutterError(
                            code: "hyperpay-transaction-error",
                            message: "Transaction error during opening the payment page.",
                            details: "\(error.debugDescription)"
                        )
                    );
                    return;
                }
                
                if transaction.type == .synchronous {
                    self.processSyncronousPayment();
                    return;
                }
                
                if transaction.type == .asynchronous {
                    self.processAsyncronousPayment();
                    return;
                }
                
                self.hyperpayResult(
                    FlutterError(
                        code: "hyperpay-transaction-failure",
                        message: "Transaction failed for unknown reason.",
                        details: "If you think this is a bug, please file an issue in the GitHub repository: https://github.com/YazeedAlKhalaf/hyperpay."
                    )
                );
                return;
            },
            cancelHandler: {
                self.hyperpayResult(
                    FlutterError(
                        code: "hyperpay-transaction-canceled",
                        message: "Transaction canceled.",
                        details: "Transaction was canceled prematurely."
                    )
                );
                return;
            }
        )
    }
    
    /// processes the payment in case it is syncronous.
    /// returns a success message indicating that the payment is done.
    private func processSyncronousPayment() {
        // return a string that says "success" indicating the successful
        // processing of the payment.
        DispatchQueue.main.async {
            self.hyperpayResult("success");
        }
    }
    
    /// processes the payment in case it is asyncronous.
    private func processAsyncronousPayment() {
        // add a notification observer to check when payment is done.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didReceiveAsynchronousPaymentCallback),
            name: receivePaymentAsyncronouslyNotificationName,
            object: nil
        );
    }
    
    /// a callback method that removes a notification observer because payment is done.
    /// dismisses the checkout pages.
    /// returns a success message indicating that the payment is done.
    @objc func didReceiveAsynchronousPaymentCallback() {
        // remove a notification observer because payment is done.
        NotificationCenter.default.removeObserver(
            self,
            name: receivePaymentAsyncronouslyNotificationName,
            object: nil
        );
        
        // close checkout pages to make sure the shopper's data is safe.
        self.checkoutProvider.dismissCheckout(
            animated: true
        ) {
            // return a string that says "success" indicating the successful
            // processing of the payment.
            DispatchQueue.main.async {
                self.hyperpayResult("success");
            }
        };
    }
}
