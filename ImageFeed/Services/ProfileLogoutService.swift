import Foundation
import WebKit


final class ProfileLogoutService {
    // MARK: - Singleton
    static let shared = ProfileLogoutService()
    
    // MARK: - Inits
    private init() { }
    
    // MARK: - Public Methods
    func logout() {
        clearCookies()
        OAuth2TokenStorage.shared.clearToken()
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearProfileImage()
        ImagesListService.shared.clearImagesList()
        switchToSplashView()
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
    
    func switchToSplashView() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure(Constants.Errors.failedWindow)
            return
        }
        
        let splashView = SplashViewController()
        window.rootViewController = splashView
    }
}
