import Foundation

private enum AuthConstants {
    static let accessKey = "WTPbKPLD7gWVQCvrbJRzrt_rIwYCoevVitNRhMiExZ0"
    static let secretKey = "9Z5Law4941dfR7phZCDpg_bAlfKvN042RjsqdeaM_Kw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    #warning("Check if this is correct")
    static let defaultBaseURL: URL? = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString =
        "https://unsplash.com/oauth/authorize"
    static let oauthPath = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String
    let oauthPath: String

    static let standard = AuthConfiguration(
        accessKey: AuthConstants.accessKey,
        secretKey: AuthConstants.secretKey,
        redirectURI: AuthConstants.redirectURI,
        accessScope: AuthConstants.accessScope,
        defaultBaseURL: AuthConstants.defaultBaseURL,
        authURLString: AuthConstants.unsplashAuthorizeURLString,
        oauthPath: AuthConstants.oauthPath
    )
}
