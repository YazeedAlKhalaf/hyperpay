#import "HyperpayPlugin.h"

@implementation HyperpayPlugin

// data from flutter variables.
NSString* checkoutId = @"";
NSString* shopperResultURL = @"";

// platform channel variables.
FlutterMethodCall* hyperpayMethodCall;
FlutterResult hyperpayResult;

// hyperpay sdk variables.
OPPCheckoutProvider* checkoutProvider;
OPPProviderMode paymentProviderMode = OPPProviderModeTest;
OPPPaymentProvider* paymentProvider;
OPPCheckoutSettings* checkoutSettings;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    checkoutSettings = [[OPPCheckoutSettings alloc] init];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"hyperpay"
                                     binaryMessenger:[registrar messenger]];
    HyperpayPlugin* instance = [[HyperpayPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // set the `call` to `hyperpayMethodCall` so it is accessible in the whole class.
    hyperpayMethodCall = call;
    // set the `result` to `hyperpayResult` so it is accessible in the whole class.
    hyperpayResult = result;
    
    // "getHyperpayResponse" method.
    if ([hyperpayMethodCall.method isEqualToString:@"getHyperpayResponse"]) {
        hyperpayResult([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
        return;
    }
    
    hyperpayResult([
        FlutterError
        errorWithCode:@"hyperpay-method-not-found"
        message:@"Method name not found."
        details:@"If you think this is a bug, please file an issue in the GitHub repository: https://github.com/YazeedAlKhalaf/hyperpay."
    ]);
}

@end
