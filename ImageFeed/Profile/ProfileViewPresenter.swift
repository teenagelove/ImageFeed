import Foundation


public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    private let profileService: ProfileServiceProtocol
    private let imageService: ProfileImageServiceProtocol

    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        imageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ) {
        self.profileService = profileService
        self.imageService = imageService
    }

    func viewDidLoad() {
        guard let profile = profileService.profile else {
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
            let profileImageURL = imageService.avatarURL,
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
