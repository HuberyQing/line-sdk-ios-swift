//
//  LineSDKError.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

/// `LineSDKError` is the error type returned by the LINE SDK. It encompasses different types of errors
/// that have their own associated reasons.
///
/// You can switch over to each error to know the detailed reason and associated information. You can also
/// access the `localizedDescription` property to get a human-readable text description. Access `errorCode`
/// to get a fixed error code to identify the error type quickly. All `LineSDKError`s are under the
/// "LineSDKError" error domain.
///
/// - requestFailed: An error occurred while constructing a request.
/// - responseFailed: An error occurred while handling a response.
/// - authorizeFailed: An error occurred while authorizing a user.
/// - generalError: An error occurred while performing another process in the LINE SDK.
public enum LineSDKError: Error {
    
    /// The underlying reason why a `.requestFailed` error occurs.
    ///
    /// - missingURL: The `URL` object is missing while encoding a request. Code 1001.
    /// - lackOfAccessToken: The request requires an access token but it is unavailable. Code 1002.
    /// - jsonEncodingFailed: The request requires a JSON body but provided data cannot be encoded to
    ///                       valid JSON. Code 1003.
    public enum RequestErrorReason {
        /// `URL` is missing while encoding a request. Code 1001.
        case missingURL
        
        /// The request requires an access token, but there is no one. Code 1002.
        case lackOfAccessToken
        
        /// The request requires a JSON body, but provided data cannot be encoded to valid JSON. Code 1003.
        case jsonEncodingFailed(Error)
    }
    
    /// The underlying reason why a `.responseFailed` error occurs.
    ///
    /// - URLSessionError: An error occurred in the underlying `URLSession` object. Code 2001.
    /// - nonHTTPURLResponse: The response is not a valid `HTTPURLResponse` object. Code 2002.
    /// - dataParsingFailed: The received data cannot be persed to an instance of the target type. Code
    ///                      2003.
    /// - invalidHTTPStatusAPIError: The received response contains an invalid HTTP status code. Code 2004.
    public enum ResponseErrorReason {
        
        public struct APIErrorDetail {
            let code: Int
            let error: APIError?
            let raw: HTTPURLResponse
            let rawString: String?
        }
        
        /// Error happens in the underlying `URLSession`. The system `URLSessionError` value is associated. Code 2001.
        case URLSessionError(Error)
        
        /// The response is not a valid `HTTPURLResponse`. Code 2002.
        case nonHTTPURLResponse
        
        /// Cannot parse received data to an instance of target type. Code 2003.
        /// - Associated values: Parsing destination type, original data, and system underlying error.
        case dataParsingFailed(Any.Type, Data, Error)
        
        /// Received response contains an invalid HTTP status code. Associated `APIErrorDetail` contains information
        /// of the error detail. If the response data can be converted to an `APIError` object,
        /// it will be associated with an `APIErrorDetail`, in which `error` property indicates what is going wrong.
        /// Otherwise, the `detail.error` will be `nil`. In both cases, `detail.raw` and `detail.rawString` will
        /// contain the plain response and error text respectively. Code 2004.
        case invalidHTTPStatusAPIError(detail: APIErrorDetail)
    }
    
    /// The underlying reason why an `.authorizeFailed` error occurs.
    ///
    /// - exhaustedLoginFlow: There is no other login method left. The login process cannot be completed.
    ///                       Code 3001.
    /// - malformedHierarchy: The view hierarchy or view controller hierarchy is malformed and the LINE
    ///                       SDK cannot show its login view controller. Code 3002.
    /// - userCancelled: The user cancelled or interrupted the login process. Code 3003.
    /// - forceStopped: The `stop` method is called during the login process. Code 3004.
    /// - callbackURLSchemeNotMatching: The received `URL` object while opening the app does not match the
    ///                                 defined URL scheme. Code 3005.
    /// - invalidSourceApplication: The source application is invalid and cannot finish the authorization
    ///                             process. Code 3006.
    /// - malformedRedirectURL: The received `URL` object while opening the app is invalid or does not
    ///                         contain necessary information. Code 3007.
    /// - invalidLineURLResultCode: The received `URL` object while opening the app has an unknown result
    ///                             code. Code 3008.
    /// - lineClientError: An error occurs in the LINE app during the authorization process. Code 3009.
    /// - responseStateValueNotMatching: Failed to verify the `state` value. The received URL response is
    ///                                  not from the original authorization request. Code 3010.
    /// - webLoginError: An error occurrs in the web login flow during the authorization process. Code 3011.
    /// - keychainOperation: An error occurrs while accessing the keychain. It prevents the LINE SDK from
    ///                      loading data from or writing data to the keychain. Code 3012.
    /// - invalidDataInKeychain: The retrieved authorization information from the keychain cannot be
    ///                          converted to valid data. Code 3013.
    /// - lackOfIDToken: The authorization request contains the OpenID scope, but any ID token is not found
    ///                  in or parsed from the server response. Code 3014.
    /// - JWTPublicKeyNotFound: The public key is not found for a give key ID or the key ID does not exist. Code
    ///                         3015.
    /// - cryptoError: An error occurred at the LINE SDK crypto part. Usually this indicates a malformed
    ///                certificate or a key, or an unsupported algorithm is used. For more information, see
    ///                `CryptoError`. Code 3016.
    public enum AuthorizeErrorReason {
        
        /// There is no other login methods left. The login process cannot be completed. Code 3001.
        case exhaustedLoginFlow
        
        /// The view hierarchy or view controller hierarchy is malformed and LineSDK cannot present
        /// its login view controller. Code 3002.
        case malformedHierarchy
        
        /// User cancelled or interrupted the login process. Code 3003.
        case userCancelled
        
        /// `stop` method is called on the login process. Code 3004.
        case forceStopped
        
        /// The received `URL` while opening app does not match the URL scheme defined. Code 3005.
        case callbackURLSchemeNotMatching
        
        /// The source application is invalid to finish auth process. Code 3006.
        case invalidSourceApplication
        
        /// The received `URL` while opening app is not a valid one, or does not contain all
        /// necessary information. Code 3007.
        /// - url: The url which is used to open current app.
        /// - message: A human readable message to describe the error reason.
        case malformedRedirectURL(url: URL, message: String?)
        
        /// An unknown `resultCode` in the opening app `URL`. Code 3008.
        /// - Associated value: The `resultCode` in the response url.
        case invalidLineURLResultCode(String)
        
        /// An error happens in the LINE client app while auth process. Code 3009.
        /// - code: The code returned by LINE client during the authorization.
        /// - message: The message describes the error.
        case lineClientError(code: String, message: String?)
        
        /// Invalid `state` verification. Received URL response is not from the original auth request. Code 3010.
        /// - expected: Expected state value.
        /// - got: The state value actually got from URL response.
        case responseStateValueNotMatching(expected: String, got: String?)
        
        /// An error happens in the web login flow while auth process. Code 3011.
        /// - error: Error reason when login with web flow.
        /// - description: A human readable message to describe the error reason.
        case webLoginError(error: String, description: String?)
        
        /// An error happens in keychain access which prevents LineSDK loads or writes to keychain. Code 3012.
        /// - status: The `OSStatus` number system gives.
        case keychainOperation(status: OSStatus)
        
        /// The retrieved auth information from keychain cannot be converted to valid data. Code 3013.
        case invalidDataInKeychain
        
        /// The authorization contains openID permission, but ID token cannot be found or parsed in
        /// server response. Code 3014.
        /// - raw: Raw value of the ID Token, which cannot be parsed correctly.
        case lackOfIDToken(raw: String?)
        
        /// Public key not found for a give key ID or the key ID does not exist. Code 3015.
        /// - keyID: The key ID specified in ID Token header which should be used.
        case JWTPublicKeyNotFound(keyID: String?)
        
        /// Something wrong happened inside LineSDK crypto part. This usually indicates a malformed
        /// certificate or key error, or an unsupport algorithm is used. See `CryptoError` for more.
        /// Code 3016.
        /// - error: Underlying `CryptoError` value.
        case cryptoError(error: CryptoError)
    }
    
    /// The underlying reason why a `.generalError` occurs.
    ///
    /// - conversionError: Cannot convert `string` to valid data with `encoding`.
    /// - parameterError: The method is invoked with an invalid parameter.
    public enum GeneralErrorReason {
        /// Cannot convert target `string` to valid data under `encoding`.
        case conversionError(string: String, encoding: String.Encoding)
        
        /// Method invoked with an invalid parameter.
        case parameterError(parameterName: String, description: String)
    }
    
    case requestFailed(reason: RequestErrorReason)
    case responseFailed(reason: ResponseErrorReason)
    case authorizeFailed(reason: AuthorizeErrorReason)
    case generalError(reason: GeneralErrorReason)
}

// MARK: - Classifies the Error
extension LineSDKError {
    /// Checks whether the `LineSDKError` is a request error.
    public var isRequestError: Bool {
        if case .requestFailed = self {
            return true
        }
        return false
    }
    
    /// Checks whether the `LineSDKError` is a response error.
    public var isResponseError: Bool {
        if case .responseFailed = self {
            return true
        }
        return false
    }
    
    /// Checks whether the `LineSDKError` is an authorization error.
    public var isAuthorizeError: Bool {
        if case .authorizeFailed = self {
            return true
        }
        return false
    }
    
    /// Checks whether the `LineSDKError` is a general error.
    public var isGeneralError: Bool {
        if case .generalError = self {
            return true
        }
        return false
    }
}

// MARK: - Convenience Properties
extension LineSDKError {
    /// Checks whether the `LineSDKError` is an authorization error and the reason is `.userCancelled`.
    public var isUserCancelled: Bool {
        if case .authorizeFailed(.userCancelled) = self {
            return true
        }
        return false
    }
    
    /// Checks whether the `LineSDKError` is a bad request error.
    public var isBadRequest: Bool {
        return isResponseError(statusCode: 400)
    }
    
    /// Checks whether the `LineSDKError` is a refresh token error. Usually, when the user uses an expired
    /// access token to send an API request, an automatic token refresh operation with the current refresh token
    /// will be triggered. This error usually occurs when the refresh token also expires or is invalid. If this
    /// error occurs, let the user logs in again before you can continue to use LINE APIs.
    public var isRefreshTokenError: Bool {
        let refreshTokenRequest = PostRefreshTokenRequest(channelID: "", refreshToken: "")
        let url = refreshTokenRequest.baseURL.appendingPathComponentIfNotEmpty(refreshTokenRequest.path)
        return isResponseError(statusCode: 400, url: url)
    }
    
    /// Checks whether the `LineSDKError` is a permission granting error. Usually, it means you do not have
    /// enough permission to access an endpoint of the LINE API.
    public var isPermissionError: Bool {
        return isResponseError(statusCode: 403)
    }
    
    /// Checks whether the `LineSDKError` is an access token error. Usually, it means the user's access token is
    /// expired or malformed.
    public var isTokenError: Bool {
        return isResponseError(statusCode: 401)
    }

    /// Checks whether the `LineSDKError` occurs because of a response failing with a specified HTTP status code.
    ///
    /// - Parameters:
    ///   - statusCode: The status code to check whether it matches with the returned HTTP status error code.
    ///   - url: The URL to check with the URL of error response. If `nil`, the URL matching check is skipped.
    /// - Returns: `true` if `self` is an `.invalidHTTPStatusAPIError` with the given `statusCode` and `url`;
    ///            `false` otherwise.
    public func isResponseError(statusCode: Int, url: URL? = nil) -> Bool {
        if case .responseFailed(.invalidHTTPStatusAPIError(let detail)) = self {
            let codeMatch = detail.code == statusCode
            
            let urlMatch: Bool
            if let url = url {
                urlMatch = url == detail.raw.url
            } else {
                urlMatch = true
            }
            
            return codeMatch && urlMatch
        }
        return false
    }
    
    /// Checks whether the `LineSDKError` is a time out error caused by the underlying URL session error.
    public var isURLSessionTimeout: Bool {
        return isURLSessionErrorCode(sessionErrorCode: NSURLErrorTimedOut)
    }
    
    /// Checks whether the `LineSDKError` is a URL session error with a specified error code.
    ///
    /// - Parameter code: The underlying URL session error code. See `URLError` in the documentation for the
    ///                   Foundation framework.
    /// - Returns: `true` if `self` is a `.URLSessionError` error with the given `code`; `false` otherwise.
    public func isURLSessionErrorCode(sessionErrorCode code: Int) -> Bool {
        if case .responseFailed(.URLSessionError(let error)) = self {
            let nsError = error as NSError
            return nsError.code == code
        }
        return false
    }
}

// MARK: - Error Description
extension LineSDKError: LocalizedError {
    /// Describes why an error occurs in human-readable text.
    public var errorDescription: String? {
        switch self {
        case .requestFailed(reason: let reason): return reason.errorDescription
        case .responseFailed(reason: let reason): return reason.errorDescription
        case .authorizeFailed(reason: let reason): return reason.errorDescription
        case .generalError(reason: let reason): return reason.errorDescription
        }
    }
}

// MARK: - NSError Compatibility
extension LineSDKError: CustomNSError {
    public var errorCode: Int {
        switch self {
        case .requestFailed(reason: let reason): return reason.errorCode
        case .responseFailed(reason: let reason): return reason.errorCode
        case .authorizeFailed(reason: let reason): return reason.errorCode
        case .generalError(reason: let reason): return reason.errorCode
        }
    }
    
    public var errorUserInfo: [String : Any] {
        switch self {
        case .requestFailed(reason: let reason): return reason.errorUserInfo
        case .responseFailed(reason: let reason): return reason.errorUserInfo
        case .authorizeFailed(reason: let reason): return reason.errorUserInfo
        case .generalError(reason: let reason): return reason.errorUserInfo
        }
    }
    
    public static var errorDomain: String {
        return "LineSDKError"
    }
}

// MARK: - Private Definition
extension LineSDKError.RequestErrorReason {

    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "URL is missing while encoding a request."
        case .lackOfAccessToken:
            return "The request requires an access token, but there is no one."
        case .jsonEncodingFailed(let error):
            return "The request requires a JSON body, but provided data cannot be encoded to valid JSON. \(error)"
        }
    }
    
    var errorCode: Int {
        switch self {
        case .missingURL:         return 1001
        case .lackOfAccessToken:  return 1002
        case .jsonEncodingFailed: return 1003
        }
    }
    
    var errorUserInfo: [String: Any] {
        var userInfo: [LineSDKErrorUserInfoKey: Any] = [:]
        switch self {
        case .missingURL: break
        case .lackOfAccessToken: break
        case .jsonEncodingFailed(let error):
            userInfo[.underlyingError] = error
        }
        return .init(uniqueKeysWithValues: userInfo.map { ($0.rawValue, $1) })
    }
}

extension LineSDKError.ResponseErrorReason {
    var errorDescription: String? {
        switch self {
        case .URLSessionError(let error):
            return "URLSession task finished with error: \(error)"
        case .nonHTTPURLResponse:
            return "The response is not a valid `HTTPURLResponse`."
        case .dataParsingFailed(let type, let data, let error):
            let result = "Parsing response data to \(type) failed: \(error)."
            if let text = String(data: data, encoding: .utf8) {
                return result + "\nOriginal: \(text)"
            } else {
                return result
            }
        case .invalidHTTPStatusAPIError(let detail):
            let url = detail.raw.url?.absoluteString ?? "null"
            if let error = detail.error {
                return "HTTP status code is not valid in response (request: \(url)). " +
                       "Code: \(detail.code), error: \(error.error), raw data: \(detail.rawString ?? "nil")"
            } else {
                return "HTTP status code is not valid in response (request: \(url)). " +
                       "Code: \(detail.code), raw data: \(detail.rawString ?? "nil")"
            }
        }
    }
    
    var errorCode: Int {
        switch self {
        case .URLSessionError:           return 2001
        case .nonHTTPURLResponse:        return 2002
        case .dataParsingFailed:         return 2003
        case .invalidHTTPStatusAPIError: return 2004
        }
    }
    
    var errorUserInfo: [String: Any] {
        var userInfo: [LineSDKErrorUserInfoKey: Any] = [:]
        switch self {
        case .URLSessionError(let error):
            userInfo[.underlyingError] = error
        case .nonHTTPURLResponse:
            break
        case .dataParsingFailed(let type, let data, let error):
            userInfo[.underlyingError] = error
            userInfo[.type] = type
            userInfo[.data] = data
        case .invalidHTTPStatusAPIError(let detail):
            userInfo[.statusCode] = detail.code
            userInfo[.raw] = detail.raw
            if let error = detail.error { userInfo[.APIError] = error }
            if let rawtString = detail.rawString { userInfo[.message] = rawtString }
        }
        return .init(uniqueKeysWithValues: userInfo.map { ($0.rawValue, $1) })
    }
}

extension LineSDKError.AuthorizeErrorReason {
    var errorDescription: String? {
        switch self {
        case .exhaustedLoginFlow:
            return "There is no other login methods left. The login process cannot be completed."
        case .malformedHierarchy:
            return "The view hierarchy or view controller hierarchy is malformed and LineSDK cannot " +
                   "present its login view controller."
        case .userCancelled:
            return "User cancelled or interrupted the login process."
        case .forceStopped:
            return "Method stop is called on the login process."
        case .callbackURLSchemeNotMatching:
            return "The received `URL` while opening app does not match the URL scheme defined."
        case .invalidSourceApplication:
            return "The source application is invalid to finish auth process."
        case .malformedRedirectURL(let url, let message):
            return "The received `URL` while opening app is not a valid one, " +
                   "or does not contain all necessary information. URL: \(url), message: \(message ?? "nil")."
        case .invalidLineURLResultCode(let code):
            return "An unknown `resultCode` (\(code)) in the opening app `URL`."
        case .lineClientError(let code, let message):
            return "LINE client app failed while auth process. Error: \(code), message: \(message ?? "nil")"
        case .responseStateValueNotMatching(_, _):
            return "Invalid `state` verification. Received URL response is not from the original auth request."
        case .webLoginError(let error, let message):
            return "Web login flow failed while auth process. Error: \(error), message: \(message ?? "nil")"
        case .keychainOperation(let status):
            return "Writing or loading token failed. Keychain operation error: \(status)"
        case .invalidDataInKeychain:
            return "The retrieved auth information from keychain cannot be converted to valid data."
        case .lackOfIDToken(let raw):
            return "Authorization permission contains .openID, but no ID Token can be found or parsed in response. " +
                   "Raw: \(String(describing: raw))"
        case .JWTPublicKeyNotFound(let keyID):
            return "Cannot find a JWT public key in JWKs for Key ID: \(keyID ?? "nil")"
        case .cryptoError(let error):
            return "CryptoError: \(error.errorDescription ?? "nil")"
        }
    }
    
    var errorCode: Int {
        switch self {
        case .exhaustedLoginFlow:            return 3001
        case .malformedHierarchy:            return 3002
        case .userCancelled:                 return 3003
        case .forceStopped:                  return 3004
        case .callbackURLSchemeNotMatching:  return 3005
        case .invalidSourceApplication:      return 3006
        case .malformedRedirectURL:          return 3007
        case .invalidLineURLResultCode:      return 3008
        case .lineClientError:               return 3009
        case .responseStateValueNotMatching: return 3010
        case .webLoginError:                 return 3011
        case .keychainOperation:             return 3012
        case .invalidDataInKeychain:         return 3013
        case .lackOfIDToken:                 return 3014
        case .JWTPublicKeyNotFound:          return 3015
        case .cryptoError:                   return 3016
        }
    }
    
    var errorUserInfo: [String: Any] {
        var userInfo: [LineSDKErrorUserInfoKey: Any] = [:]
        switch self {
        case .exhaustedLoginFlow: break
        case .malformedHierarchy: break
        case .userCancelled: break
        case .forceStopped: break
        case .callbackURLSchemeNotMatching: break
        case .invalidSourceApplication: break
        case .malformedRedirectURL(let url, let message):
            userInfo[.url] = url
            if let message = message { userInfo[.message] = message }
        case .invalidLineURLResultCode(let code):
            userInfo[.resultCode] = code
        case .lineClientError(let code, let message):
            userInfo[.resultCode] = code
            if let message = message { userInfo[.message] = message }
        case .responseStateValueNotMatching(_, _):
            userInfo = [:]
        case .webLoginError(let error, let message):
            userInfo[.underlyingError] = error
            if let message = message { userInfo[.message] = message }
        case .keychainOperation(let status):
            userInfo[.status] = status
        case .invalidDataInKeychain: break
        case .lackOfIDToken(let raw):
            if let raw = raw { userInfo[.raw] = raw }
        case .JWTPublicKeyNotFound(let keyID):
            if let keyID = keyID { userInfo[.raw] = keyID }
        case .cryptoError(let error):
            userInfo[.underlyingError] = error
        }
        return .init(uniqueKeysWithValues: userInfo.map { ($0.rawValue, $1) })
    }
}

extension LineSDKError.GeneralErrorReason {
    var errorDescription: String? {
        switch self {
        case .conversionError(let text, let encoding):
            return "Cannot convert target \"\(text)\" to valid data under \(encoding) encoding."
        case .parameterError(let parameterName, let reason):
            return "Method invoked with an invalid parameter \"\(parameterName)\". Reason: \(reason)"
        }
    }
    
    var errorCode: Int {
        switch self {
        case .conversionError(_, _): return 4001
        case .parameterError(_, _):  return 4002
        }
    }
    
    var errorUserInfo: [String: Any] {
        var userInfo: [LineSDKErrorUserInfoKey: Any] = [:]
        switch self {
        case .conversionError(let text, let encoding):
            userInfo[.text] = text
            userInfo[.encoding] = encoding
        case .parameterError(let parameterName, let reason):
            userInfo[.parameterName] = parameterName
            userInfo[.reason] = reason
        }
        return .init(uniqueKeysWithValues: userInfo.map { ($0.rawValue, $1) })
    }
}

public enum LineSDKErrorUserInfoKey: String {
    case underlyingError
    case statusCode
    case resultCode
    case type
    case data
    case APIError
    case raw
    case url
    case message
    case status
    case text
    case encoding
    case parameterName
    case reason
    case index
    case key
    case got
}

