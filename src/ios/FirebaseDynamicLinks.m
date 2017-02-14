#import "FirebaseDynamicLinks.h"

@implementation FirebaseDynamicLinks {
    id <FIRInviteBuilder> _inviteDialog;
    NSString *_sendInvitationCallbackId;
}

- (void)pluginInitialize {
    if(![FIRApp defaultApp]) {
        [FIRApp configure];
    }

    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
}

- (void)onDynamicLink:(CDVInvokedUrlCommand *)command {
    self.dynamicLinkCallbackId = command.callbackId;

    if (self.cachedInvitation) {
        [self sendDynamicLinkData:self.cachedInvitation];

        self.cachedInvitation = nil;
    }
}

// NOTE: You must have the App Store ID set in your developer console project in order for invitations to successfully be sent.
- (void)sendInvitation:(CDVInvokedUrlCommand *)command {
    NSDictionary* options = command.arguments[0];

    // Only title and message properties are mandatory (and checked in JS API)
    NSString *title = options[@"title"];
    NSString *message = options[@"message"];

    NSString *deepLink = options[@"deepLink"];
    NSString *callToActionText = options[@"callToActionText"];
    NSString *customImage = options[@"customImage"];
    NSString *description = options[@"description"];
    NSString *androidClientID = options[@"androidClientID"];
    NSString *androidMinimumVersion = options[@"androidMinimumVersion"];

    _sendInvitationCallbackId = command.callbackId;

    _inviteDialog = [FIRInvites inviteDialog];
    [_inviteDialog setInviteDelegate:self];


    // A message hint for the dialog. Note this manifests differently depending on the received invitation type.
    // For example, in an email invite this appears as the subject.
    [_inviteDialog setMessage:message];

    // Title for the dialog, this is what the user sees before sending the invites.
    [_inviteDialog setTitle:title];

    [_inviteDialog setDescription:description];
    [_inviteDialog setDeepLink:deepLink];
    [_inviteDialog setCallToActionText:callToActionText];
    [_inviteDialog setCustomImage:customImage];

    // in case an Android app is available as well:
    if (androidClientID) {
        FIRInvitesTargetApplication *targetApplication = [FIRInvitesTargetApplication new];
        // The Android client ID from the Google API console project (?)
        targetApplication.androidClientID = androidClientID;
        [_inviteDialog setOtherPlatformsTargetApplication:targetApplication];
    }

    if (androidMinimumVersion) {
        [_inviteDialog setAndroidMinimumVersionCode:[androidMinimumVersion integerValue]];
    }

    self.isSigningIn = YES;

    [[GIDSignIn sharedInstance] signIn];
}

- (void)sendDynamicLinkData:(NSDictionary *)data {
    if (self.dynamicLinkCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dynamicLinkCallbackId];
    } else {
        self.cachedInvitation = data;
    }
}

#pragma mark FIRInviteDelegate
- (void)inviteFinishedWithInvitations:(NSArray *)invitationIds
                                error:(nullable NSError *)error
{
    __block CDVPluginResult *pluginResult;
    if (error) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:invitationIds];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_sendInvitationCallbackId];
}

#pragma mark GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        [_inviteDialog open];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
            @"type": @"signinfailure",
            @"data": @{
                    @"code": @(error.code),
                    @"message": error.description
            }
        }];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:_sendInvitationCallbackId];
    }
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    self.isSigningIn = YES;

    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)logEvent:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSString* name = [command.arguments objectAtIndex:0];
        NSDictionary* parameters = [command.arguments objectAtIndex:1];
        
        [FIRAnalytics logEventWithName:name parameters:parameters];
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
