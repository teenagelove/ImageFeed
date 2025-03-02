import Foundation
import SwiftKeychainWrapper


final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            return keychain.string(forKey: Constants.Storage.accessToken)
        }
        set {
            guard let newValue else {
                keychain.removeObject(forKey: Constants.Storage.accessToken)
                return
            }
            keychain.set(newValue, forKey: Constants.Storage.accessToken)
        }
    }
    
    private let keychain = KeychainWrapper.standard
    
    private init() {}
    
    func clearToken() {
        token = nil
    }
}
