# cordova-plugin-firebase-dynamiclinks<br>[![NPM version][npm-version]][npm-url] [![NPM downloads][npm-downloads]][npm-url]
> Cordova plugin for [Firebase Invites](https://firebase.google.com/docs/invites/) and [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/)
 
 This version adds support for "logEvent" and firebase analytics in general.
 
## Installation

    cordova plugin add https://github.com/simllll/cordova-plugin-firebase-dynamiclinks --save --variable APP_DOMAIN="example.com" --variable APP_PATH="/" --variable REVERSED_CLIENT_ID="reversed client id"

Variables `APP_DOMAIN` and `APP_PATH` specify web URL where your app will start an activity to handle the link. They also used to setup support for [App Indexing](https://firebase.google.com/docs/app-indexing/). Additionally provide an Reversed Client Id (see GoogleSerice-Info.plist).

Verify that GoogleService-Info.plist has follwoing attributes, if not add them:
TRACKING_ID (get it from google analytics)
API_KEY (get from https://console.developers.google.com/apis/credentials)
optional: IS_APP_INVITE_ENABLED to false (in case you have not enabled it in firebase)

Go to firebase console and export `google-services.json` and `GoogleService-Info.plist`. Put those files into the root of your cordova app folder.

## Supported Platforms

- iOS
- Android (logEvent not implemented)

## Methods

### onDynamicLink(_callback_)
Registers callback that is triggered on each dynamic link click.
```js
window.cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(data) {
    console.log("Dynamic link click with data: ", data);
});
```

### sendInvitation(_config_)
Display invitation dialog.
```js
window.cordova.plugins.firebase.dynamiclinks.sendInvitation({
    deepLink: deepLink,
    title: dialogTitle,
    message: dialogMessage,
    callToActionText: actionButtonText,
    iosClientID: iosClientID,
    androidClientID: androidClientID
});
```
### logEvent(name, attrs)
logs event to firebase
 ```js
window.cordova.plugins.firebase.dynamiclinks.logEvent("eventName", {
    params: "blub"
});
```

[npm-url]: https://www.npmjs.com/package/cordova-plugin-firebase-dynamiclinks
[npm-version]: https://img.shields.io/npm/v/cordova-plugin-firebase-dynamiclinks.svg
[npm-downloads]: https://img.shields.io/npm/dt/cordova-plugin-firebase-dynamiclinks.svg

