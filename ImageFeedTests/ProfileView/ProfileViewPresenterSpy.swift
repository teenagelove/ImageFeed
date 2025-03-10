import ImageFeed


final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled = false
    var updateAvatarCalled = false
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() { }
    
    func logout() { }
}
