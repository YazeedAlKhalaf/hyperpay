#import <Flutter/Flutter.h>
#import <OPPWAMobile/OPPWAMobile.h>

@interface HyperpayPlugin : NSObject<FlutterPlugin, OPPCheckoutProviderDelegate>

- (void)getHyperpayResponse;

- (void)initializeArgumentsFromHyperpayMethodCall;

- (void)processWithCustomUI;

- (void)processSyncronousPayment;

- (void)processAsyncronousPayment;

- (void)didReceiveAsynchronousPaymentCallback;

@end
