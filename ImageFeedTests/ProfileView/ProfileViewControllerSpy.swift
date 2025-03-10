@testable import ImageFeed
import Foundation


final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    var displayProfileDataCalled = false
    var displayedName: String?
    var displayedLogin: String?
    var displayedDescription: String?
    
    var downloadAvatarCalled = false
    var avatarURL: String?
    
    func displayProfileData(name: String, login: String, description: String) {
        displayProfileDataCalled = true
        displayedName = name
        displayedLogin = login
        displayedDescription = description
    }
    
    func downloadAvatar(url: URL) {
        downloadAvatarCalled = true
        avatarURL = url.absoluteString
    }
}
