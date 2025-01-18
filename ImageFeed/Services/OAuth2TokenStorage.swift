import Foundation


final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            return userDefaults.string(forKey: Constants.Storage.accessToken)
        }
        set {
            userDefaults.setValue(newValue, forKey: Constants.Storage.accessToken)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
}
