import Foundation


protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set}
    func viewDidLoad()
    func updateAvatar()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        guard let profile = ProfileService.shared.profile else {
            print(Constants.Errors.failedFetchProfile)
            return
        }
        
        view?.displayProfileData(
            name: profile.name,
            login: profile.loginName,
            description: profile.bio ?? ""
        )
        
        updateAvatar()
    }
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.downloadAvatar(url: url)
    }
    
    func logout() {
        guard let view else { return }
        AlertPresenter.showLogoutWarning(vc: view) {
            UIBlockingProgressHUD.show()
            ProfileLogoutService.shared.logout()
        }
    }
}
