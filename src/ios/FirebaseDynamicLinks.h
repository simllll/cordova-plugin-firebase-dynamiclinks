#import <Cordova/CDV.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "AppDelegate.h"
#import "Firebase.h"

@interface FirebaseDynamicLinks : CDVPlugin<FIRInviteDelegate, GIDSignInDelegate, GIDSignInUIDelegate>

+ (FirebaseDynamicLinks *) instance;
- (void)onDynamicLink:(CDVInvokedUrlCommand *)command;
- (void)sendInvitation:(CDVInvokedUrlCommand*)command;
- (void)signIn:(CDVInvokedUrlCommand*)command;
- (void)sendDynamicLinkData:(NSDictionary*)data;

@property (nonatomic, copy) NSString *dynamicLinkCallbackId;
@property NSDictionary* cachedInvitation;

@end
