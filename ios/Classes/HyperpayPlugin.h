#import <Flutter/Flutter.h>
#import <OPPWAMobile/OPPWAMobile.h>

@interface HyperpayPlugin : NSObject<FlutterPlugin, OPPCheckoutProviderDelegate>

- (void)getHyperpayResponse;

- (void)initializeArgumentsFromHyperpayMethodCall;

- (void)intializeCheckoutSettings;

- (void)openReadyUI;

- (void)processSyncronousPayment;

- (void)processAsyncronousPayment;

- (void)didReceiveAsynchronousPaymentCallback;

@end
