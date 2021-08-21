#import <Flutter/Flutter.h>
#import <OPPWAMobile/OPPWAMobile.h>
#import <SafariServices/SafariServices.h>

@interface HyperpayPlugin : NSObject<FlutterPlugin, OPPCheckoutProviderDelegate, SFSafariViewControllerDelegate>

- (void)getHyperpayResponse;

- (void)initializeArgumentsFromHyperpayMethodCall;

- (void)processWithCustomUI;

- (void)processSyncronousPayment;

- (void)processAsyncronousPayment;

- (void)didReceiveAsynchronousPaymentCallback;

@end
