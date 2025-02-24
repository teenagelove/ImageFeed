import Foundation
import WebKit


final class ProfileLogoutService {
    // MARK: - Singletone
    static let shared = ProfileLogoutService()
    
    // MARK: - Inits
    private init() { }
    
    func logout() {
        clearCookies()
        OAuth2TokenStorage.clearToken()
        ProfileService.clearProfile()
        ProfileImageService.clearProfileImage()
        ImagesListService.clearImagesList()
        switchToAuthView()
    }
}

// MARK: - Private Methods
private extension ProfileLogoutService {
    func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func switchToAuthView() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure(Constants.Errors.failedWindow)
            return
        }
        
        let authView = AuthViewController()
        window.rootViewController = authView
    }
}
