import UIKit


final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.Images.logo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToken()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupSubviews() {
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}


private extension SplashViewController {
    func checkToken() {
        guard let token = storage.token else {
            navigateToAuthView()
            return
        }
        
        fetchProfile(token: token)
    }
    
    func navigateToAuthView() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure(Constants.Errors.failedWindow)
            return
        }
        
        guard let tabBarController = UIStoryboard(name: "Main",bundle: nil)
                    .instantiateViewController(withIdentifier: Constants.Storyboards.tabBar) as? UITabBarController else {
                    assertionFailure(Constants.Errors.failedStoryboard)
                    return
                }
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ authViewController: AuthViewController) {
        //        TODO: Пока убрал закрытие вьюхи, чтобы не было промигивания экранов.
        //        При установке рут контроллера, стек все равно сбросится
        //        authViewController.dismiss(animated: true)
        
        guard let token = storage.token else {
            print(Constants.Errors.failedGetToken)
            return
        }
        
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        //        TODO: Здесь пока не включаем вейтер, чтобы он не вызывался два раза
        //        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
                // TODO: let profile: Profile
            case .success(let profile):
                self.fetchProfileImage(username: profile.username)
                self.switchToTabBarController()
            case .failure(let error):
                print("\(Constants.Errors.failedFetchProfile)\n\(error.localizedDescription)")
                break
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { result in
            if case .failure(let error) = result {
                print("\(Constants.Errors.failedFetchProfileImage)\n\(error.localizedDescription)")
            }
        }
    }
}
