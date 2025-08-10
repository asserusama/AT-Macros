//
//  APITypeAliasDictonary.swift
//  ATMacros
//
//  Created by Asser on 22/07/2025.
//

struct TypeAliasDictionary {
    static let aliasRegistry: [String: String] = [
        "AccountExistanceAPIResult": "AccountExistancePayload",
        "AddAddressAPIResult": "AddAddress",
        "AddToCartAPIResult": "AddToCartResponse",
        "AppSttingsAPIResult": "SettingsPayload",
        "AuthAPIResult": "AuthorizedUser",
        "CancelOrderAPIResult": "CancelOrderPayload",
        "ChangePasswordAPIResult": "Any",
        "CheckoutSummaryAPIResult": "CheckoutSummaryResponse",
        "CitiesAPIResult": "CitiesResponse",
        "CountryAPIResult": "CountryResponceModel",
        "DefaultAddressAPIResult": "DefaultAddressResponse",
        "DeleteAccountAPIResult": "DeleteAccountPayload",
        "DeleteMyAddressAPIResult": "DeleteMyAddressResponse",
        "DownloadUserDataAPIResult": "DownloadUserDataPayload",
        "EditUserProfileAPIResult": "EditUserProfileResponse",
        "FAQsAPIResult": "FAQsResponse",
        "FCMTokenCompletionHandler": "String",
        "FCMTokenResult": "String",
        "FileDownloadResult": "Void",
        "GetOrderDetails": "OrderDetailsResponseModel",
        "MyAddressesAPIResult": "MyAddressesResponse",
        "MyOrdersAPIResult": "MyOrdersReponse",
        "PasswordValidationResult": "PasswordValidationPayload",
        "PlaceOrderAPIResult": "PlaceOrderResponse",
        "PrivacyPolicyAPIResult": "LegalAndPoliciesPayload",
        "PrivacyPolicyCompletionResult": "String",
        "ProductDetailsAPIResult": "ProductDetailsResponse",
        "ProductDetailsVariationAPIResult": "ProductDetailsVariation",
        "RegistrationAPIResult": "AuthorizedUser",
        "ResetPasswordAPIResult": "Any",
        "SearchedProductsListAPIResult": "ProductsResponse",
        "ShoppingBagAPIResult": "ShoppingBagResponse",
        "SupportTicketAPIResult": "SupportTicketResponse",
        "TermsAndConditionsAPIResult": "LegalAndPoliciesPayload",
        "TermsAndConditionsCompletionResult": "String",
        "UploadAttachementCompletion": "String",
        "VerifyCodeAPIResponseResult": "OTPVerificationCompletePayload",
        "VerifyCodeAPIResult": "Void",
        "VerifyPhoneAPIResult": "OTPVerificationPayload",
        "cartItemsCountAPIResult": "CartItemsCountResponse",
        "categoriesListAPIResult": "CategoriesResponse",
        "loginAPIResult": "AuthorizedUser",
        "logoutAPIResult": "LogoutModel",
        "productsListAPIResult": "ProductsResponse"
    ]
}
