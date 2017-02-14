
var exec = require('cordova/exec');

exports.sendInvitation = function(options, onSuccess, onError) {
    var opts = options || {};
    if (!opts.title || !opts.message) {
        var errorMsg = "Both 'title' and 'message' arguments are mandatory";
        if (typeof onError === "function") {
            onError(errorMsg);
        } else {
            console.error(errorMsg);
        }
        return;
    }
    exec(onSuccess, onError, "FirebaseDynamicLinks", "sendInvitation", [opts]);
};

exports.onDynamicLink = function(onSuccess, onError) {
    exec(onSuccess, onError, "FirebaseDynamicLinks", "onDynamicLink", []);
};

exports.convertInvitation = function(invitationId, onSuccess, onError) {
    exec(onSuccess, onError, "FirebaseDynamicLinks", "convertInvitation", [invitationId]);
};

exports.logEvent = function(name, params, onSuccess, onError) {
    exec(onSuccess, onError, "FirebaseDynamicLinks", "logEvent", [name, params]);
};
