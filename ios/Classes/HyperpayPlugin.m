#import "HyperpayPlugin.h"

@implementation HyperpayPlugin

// data from flutter variables.
NSString* checkoutId = @"";
NSString* shopperResultURL = @"";

// credit card info variables.
NSString* paymentBrand = @"";
NSString* holder = @"";
NSString* number = @"";
NSString* expiryMonth = @"";
NSString* expiryYear = @"";
NSString* cvv = @"";

// platform channel variables.
FlutterMethodCall* hyperpayMethodCall;
FlutterResult hyperpayResult;

// hyperpay sdk variables.
OPPCheckoutProvider* checkoutProvider;
OPPProviderMode paymentProviderMode = OPPProviderModeTest;
OPPPaymentProvider* paymentProvider;
OPPCheckoutSettings* checkoutSettings;

// misc variables.
NSNotificationName receivePaymentAsyncronouslyNotificationName = @"AsyncPaymentCompletedNotificationKey";
SFSafariViewController* safariVC;
NSString* appBundleId;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"hyperpay"
                                     binaryMessenger:[registrar messenger]];
    HyperpayPlugin* instance = [[HyperpayPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // set the `call` to `hyperpayMethodCall` so it is accessible in the whole class.
    hyperpayMethodCall = call;
    // set the `result` to `hyperpayResult` so it is accessible in the whole class.
    hyperpayResult = result;
    
    // set the `appBundleId`.
    appBundleId = [NSString stringWithFormat:@"%@", NSBundle.mainBundle.bundleIdentifier];
    
    // "getHyperpayResponse" method.
    if ([hyperpayMethodCall.method isEqualToString:@"getHyperpayResponse"]) {
        [self getHyperpayResponse];
        return;
    }
    
    // throws a `PlatformException` because no method with provided name exists.
    hyperpayResult([
        FlutterError
        errorWithCode:@"hyperpay-method-not-found"
        message:@"Method name not found."
        details:@"If you think this is a bug, please file an issue in the GitHub repository: https://github.com/YazeedAlKhalaf/hyperpay."
    ]);
}

- (void)getHyperpayResponse {
    // runs the initialization code for arguments from `hyperpayMethodCall`.
    [self initializeArgumentsFromHyperpayMethodCall];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // process card info.
        [self processWithCustomUI];
    });
}

/// initializes the variables of the class from the arguments provided by `hyperpayMethodCall`.
- (void)initializeArgumentsFromHyperpayMethodCall {
    // get arguments from call.
    NSDictionary<NSString*, NSString*>* arguments = [hyperpayMethodCall arguments];
    
    // set `paymentProviderMode` based on `mode`.
    // defaults to test, in case the mode is "LIVE", we change it to live mode.
    NSString* mode = arguments[@"mode"];
    if ([mode isEqualToString:@"LIVE"]) {
        paymentProviderMode = OPPProviderModeLive;
    }
    // setup `paymentProvider`
    paymentProvider = [OPPPaymentProvider paymentProviderWithMode:paymentProviderMode];
    
    // set `checkoutId` in the class to the value coming from the arguments.
    checkoutId = arguments[@"checkoutId"];
    
    // set credit card values.
    paymentBrand = arguments[@"paymentBrand"];
    holder = arguments[@"holder"];
    number = arguments[@"number"];
    expiryMonth = arguments[@"expiryMonth"];
    expiryYear = arguments[@"expiryYear"];
    cvv = arguments[@"cvv"];
}

- (void)processWithCustomUI {
    NSError* cardPaymentParamsError = nil;
    OPPCardPaymentParams* params = [
        OPPCardPaymentParams
        cardPaymentParamsWithCheckoutID:checkoutId
        paymentBrand:paymentBrand
        holder:holder
        number:number
        expiryMonth:expiryMonth
        expiryYear:expiryYear
        CVV:cvv
        error:&cardPaymentParamsError
    ];
    if (cardPaymentParamsError) {
        hyperpayResult([
            FlutterError
            errorWithCode:@"hyperpay-card-payment-params-error"
            message:@"Card payment params error."
            details:[cardPaymentParamsError debugDescription]
        ]);
        return;
    }
    
    /// set the `shopperResultURL` in the card payment params.
    params.shopperResultURL = [appBundleId stringByAppendingString:@".payments://result"];
    
    /// create a transaction.
    OPPTransaction* transaction = [OPPTransaction transactionWithPaymentParams:params];
    
    /// process the transaction.
    [paymentProvider submitTransaction:transaction completionHandler:^(OPPTransaction * _Nullable transaction, NSError * _Nullable error) {
        if (error || !transaction) {
            hyperpayResult([
                FlutterError
                errorWithCode:@"hyperpay-transaction-error"
                message:@"Transaction error."
                details:[error debugDescription]
            ]);
            return;
        }
        
        if (transaction.type == OPPTransactionTypeSynchronous) {
            [self processSyncronousPayment];
            return;
        }
        
        if (transaction.type == OPPTransactionTypeAsynchronous) {
            [self processAsyncronousPayment];
            
            // show a safari view controller to finish the async payment.
            safariVC = [[SFSafariViewController alloc] initWithURL:transaction.redirectURL];
            safariVC.delegate = self;
            UIViewController* rootVC = [[[[UIApplication sharedApplication]delegate] window] rootViewController];
            [rootVC presentViewController:safariVC animated:YES completion: nil];
            return;
        }
        
        hyperpayResult([
            FlutterError
            errorWithCode:@"hyperpay-transaction-failure"
            message:@"Transaction failed for unknown reason."
            details:@"If you think this is a bug, please file an issue in the GitHub repository: https://github.com/YazeedAlKhalaf/hyperpay."
        ]);
        return;
    }];
}

/// processes the payment in case it is syncronous.
/// returns a success message indicating that the payment is done.
- (void)processSyncronousPayment {
    // return a string that says "success" indicating the successful
    // processing of the payment.
    dispatch_async(dispatch_get_main_queue(), ^{
        hyperpayResult(@"success sync");
    });
}

/// processes the payment in case it is asyncronous.
- (void)processAsyncronousPayment {
    // add a notification observer to check when payment is done.
    [NSNotificationCenter.defaultCenter
     addObserver:self
     selector: @selector(didReceiveAsynchronousPaymentCallback)
     name:receivePaymentAsyncronouslyNotificationName
     object:NULL];
}

/// a callback method that removes a notification observer because payment is done.
/// dismisses the checkout pages.
/// returns a success message indicating that the payment is done.
- (void)didReceiveAsynchronousPaymentCallback {
    // remove a notification observer because payment is done.
    [NSNotificationCenter.defaultCenter
     removeObserver:self
     name:receivePaymentAsyncronouslyNotificationName
     object:NULL];
    
    // close checkout pages to make sure the shopper's data is safe.
    [safariVC dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            hyperpayResult(@"success async");
        });
    }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.scheme caseInsensitiveCompare:[appBundleId stringByAppendingString:@".payments"]] == NSOrderedSame) {
        [self didReceiveAsynchronousPaymentCallback];
        return YES;
    } else {
        return NO;
    }
}

@end
