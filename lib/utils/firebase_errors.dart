/// 🔹 Firebase Auth Error Handler (Client + Admin + Network + Edge Cases)
String getFirebaseAuthError(String code) {
  switch (code) {
    // ----- 🔸 Common Client Errors -----
    case "invalid-email":
      return "Please enter a valid email address.";
    case "user-disabled":
      return "This account has been disabled. Contact support.";
    case "user-not-found":
      return "No account found with this email.";
    case "wrong-password":
      return "Incorrect password. Please try again.";
    case "email-already-in-use":
    case "email-already-exists":
      return "This email is already registered.";
    case "weak-password":
    case "invalid-password":
      return "Your password is too weak. Try a stronger one.";
    case "too-many-requests":
      return "Too many attempts. Please wait and try again.";
    case "operation-not-allowed":
      return "This login method is not enabled. Contact admin.";
    case "invalid-recipient-email":
      return "Invalid recipient email address.";

    // ----- 🔸 Credential & Verification -----
    case "invalid-credential":
      return "Your login credentials are invalid. Please try again.";
    case "invalid-verification-code":
      return "Invalid verification code. Please check and try again.";
    case "invalid-verification-id":
      return "Invalid verification ID. Please restart verification.";
    case "account-exists-with-different-credential":
      return "An account already exists with a different sign-in method.";
    case "credential-already-in-use":
      return "This credential is already in use by another account.";
    case "expired-action-code":
      return "This link has expired. Please request a new one.";
    case "invalid-action-code":
      return "Invalid or expired action link. Try again.";

    // ----- 🔸 Phone & Provider -----
    case "invalid-phone-number":
      return "Please enter a valid phone number in E.164 format.";
    case "missing-phone-number":
      return "Phone number is required.";
    case "phone-number-already-exists":
      return "This phone number is already registered.";
    case "missing-verification-code":
      return "Verification code is required.";
    case "missing-verification-id":
      return "Verification ID is missing. Please retry.";
    case "invalid-provider-id":
      return "Invalid authentication provider.";
    case "provider-already-linked":
      return "This provider is already linked to your account.";

    // ----- 🔸 Network / Quota / Config -----
    case "network-request-failed":
      return "Network error. Please check your internet connection.";
    case "quota-exceeded":
      return "Server quota exceeded. Please try again later.";
    case "app-not-authorized":
      return "This app is not authorized to use Firebase Authentication.";
    case "project-not-found":
      return "Project not found or misconfigured in Firebase.";
    case "app-not-installed":
      return "Required authentication app is not installed.";
    case "missing-api-key":
      return "Firebase API key is missing from configuration.";

    // ----- 🔸 Session & Token -----
    case "id-token-expired":
    case "session-cookie-expired":
      return "Your session has expired. Please log in again.";
    case "id-token-revoked":
    case "session-cookie-revoked":
      return "Your session was revoked. Please log in again.";
    case "invalid-id-token":
      return "Invalid session token. Please log in again.";
    case "user-token-expired":
      return "Your login token has expired. Please reauthenticate.";
    case "token-expired":
      return "Your authentication token has expired.";

    // ----- 🔸 Permissions & Claims -----
    case "insufficient-permission":
      return "You don’t have permission to perform this action.";
    case "invalid-claims":
    case "reserved-claims":
      return "Invalid or reserved custom claims provided.";
    case "invalid-argument":
      return "Invalid request arguments. Please try again.";
    case "internal-error":
      return "Internal server error. Please try again later.";
    case "unauthorized-domain":
      return "Unauthorized domain used for authentication.";

    // ----- 🔸 Miscellaneous -----
    case "missing-android-pkg-name":
      return "Missing Android package name.";
    case "missing-continue-uri":
      return "Missing continue URL.";
    case "missing-ios-bundle-id":
      return "Missing iOS bundle ID.";
    case "invalid-continue-uri":
      return "Invalid continue URL.";
    case "invalid-dynamic-link-domain":
      return "Invalid dynamic link domain.";
    case "argument-error":
      return "Invalid arguments provided.";
    case "invalid-api-key":
      return "Invalid Firebase API key configured.";
    case "captcha-check-failed":
      return "Captcha verification failed. Please try again.";
    case "web-context-cancelled":
      return "The sign-in process was cancelled.";

    // ----- 🔸 UID & Display -----
    case "invalid-uid":
    case "uid-already-exists":
      return "Invalid or duplicate user ID.";
    case "invalid-display-name":
      return "Display name is invalid.";
    case "invalid-photo-url":
      return "Profile photo URL is invalid.";

    // ----- 🔸 Default -----
    default:
      return "An unexpected error occurred. [$code]";
  }
}
