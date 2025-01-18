import UIKit


final class SplashViewController: UIViewController {
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
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.authView {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure(Constants.Errors.failedSegue)
                return
            }
            
            authViewController.delegate = self
        } else { super.prepare(for: segue, sender: sender) }
    }
    
    private func checkToken() {
        guard let token = OAuth2TokenStorage.shared.token else {
            performSegue(withIdentifier: Constants.Segues.authView, sender: nil)
            return
        }
        switchToTabBarController()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure(Constants.Errors.failedWindow)
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main",bundle: nil)
            .instantiateViewController(withIdentifier: Constants.Storyboards.tabBar) as! UITabBarController
        
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ authViewController: AuthViewController) {
        authViewController.dismiss(animated: true)
        switchToTabBarController()
    }
}
