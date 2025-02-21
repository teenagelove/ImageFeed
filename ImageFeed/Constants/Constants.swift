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
        static let failedGetToken = "Failed to get token"
        static let failedWindow = "Invalid window configuration"
        static let failedStoryboard = "Invalid storyboard configuration"
        static let failedFetchProfile = "Failed to fetch profile"
        static let failedFetchProfileImage = "Failed to fetch profile image"
        static let failedEnter = "Failed to enter the system"
        static let somethingWrong = "Something went wrong"
        static let taskIsRunning = "Task already is running"
    }

    enum Images {
        static let activeLike = "Active Like"
        static let noActiveLike = "No Active Like"
        static let stubPhoto = "Stub Photo"
        static let exitProfile = "Exit"
        static let logoUnsplash = "Logo_of_Unsplash"
        static let navBackButton = "nav_back_button"
        static let logo = "Logo"
        static let stubProfile = "stub_profile"
        static let activeProfile = "tab_profile_active"
        static let backButton = "Backward"
        static let sharingButton = "Sharing"
        static let imagesList = "tab_editorial_active"
        static let unsplashLoader = "unsplash_loader"
    }

    enum UI {
        static let tableViewContentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let cellImageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
    
    enum ZoomScale {
        static let minimum = 0.05
        static let maximum = 1.25
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
        static let baseAPIUrl = "https://api.unsplash.com"
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let oauthPath = "/oauth/authorize/native"
        static let tokenPath = "/oauth/token"
        static let mePath = "/me"
        static let usersPath = "/users"
        static let photosPath = "/photos"
        static let authorizationCodeString = "authorization_code"
        static let authorizationHeader = "Authorization"
        static let bearer = "Bearer "
        static let pageQuery = "page"
        static let perPageQuery = "per_page"
        static let perPageValue = "10"
    }
    
    enum NetworkError: Error {
        case invalidRequest
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
    
    enum Notifications {
        static let profileImageServiceDidChange = "ProfileImageServiceDidChange"
        static let imagesListServiceDidChange = "ImagesListServiceDidChange"
    }
}
