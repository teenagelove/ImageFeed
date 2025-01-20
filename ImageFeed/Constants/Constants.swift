import UIKit


enum Constants {
    enum Date {
        static let defaultDateFormat = "dd MMMM yyyy"
        static let defaultLocale = "ru_RU"
    }

    enum Errors {
        static let failedCast = "Failed to cast ImagesListCell"
        static let failedImage = "Failed to load image"
        static let failedSegue = "Invalid segue destination"
        static let failedURL = "Invalid URL"
        static let failedGetCode = "Failed to get code"
        static let failedRequest = "Failed to create request"
        static let failedDecode = "Failed to decode JSON"
        static let failedFetchData = "Failed to fetch data"
        static let failedFetchToken = "Error fetching token"
        static let failedWindow = "Invalid window configuration"
        static let failedStoryboard = "Invalid storyboard configuration"
    }

    enum Images {
        static let activeLike = "Active Like"
        static let noActiveLike = "No Active Like"
        static let stubPhoto = "Stub Photo"
        static let exitProfile = "Exit"
        static let logoUnsplash = "Logo_of_Unsplash"
        static let navBackButton = "nav_back_button"
        static let logo = "Logo"
    }

    enum UI {
        static let tableViewContentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let cellImageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
    
    enum Segues {
        static let singleImage = "ShowSingleImage"
        static let webView = "ShowWebView"
        static let authView = "ShowAuthView"
        static let tableView = "ShowTableView"
    }
    
    enum ZoomScale {
        static let minimum = 0.1
        static let maximum = 1.25
    }
    
    enum MockText {
        static let name = "Екатерина Новикова"
        static let loginName = "@ekaterina_nov"
        static let description = "Hello, World!"
    }
    
    enum Fonts {
        static let header = UIFont.systemFont(ofSize: 23, weight: .medium)
        static let regular = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let loginButton = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    enum API {
        static let accessKey = "WTPbKPLD7gWVQCvrbJRzrt_rIwYCoevVitNRhMiExZ0"
        static let secretKey = "9Z5Law4941dfR7phZCDpg_bAlfKvN042RjsqdeaM_Kw"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseURL: URL? = URL(string: "https://unsplash.com")
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let oauthPath = "/oauth/authorize/native"
        static let tokenPath = "/oauth/token"
        static let authorizationCodeString = "authorization_code"
    }
    
    enum Titles {
        static let loginButton = "Войти"
    }
    
    enum Radii {
        static let loginButton: CGFloat = 16
    }
    
    enum Storage {
        static let accessToken = "accessToken"
    }
    
    enum Storyboards {
        static let tabBar = "TabBarController"
    }
}
