import UIKit


final class AuthViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let oauthService = OAuth2Service.shared
    
    // MARK: - UI Components
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.Images.logoUnsplash))
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = Constants.Radii.loginButton
        button.setTitle(Constants.Titles.loginButton, for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = Constants.Fonts.loginButton
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupBackButton()
        setupConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == Constants.Segues.webView {
                guard let webViewController = segue.destination as? WebViewViewController
                else {
                    assertionFailure(Constants.Errors.failedSegue)
                    return
                }
                webViewController.delegate = self
            } else {
                prepare(for: segue, sender: sender)
            }
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupSubviews() {
        [logoView, loginButton].forEach{ subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }
    
    private func setupBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: Constants.Images.navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Constants.Images.navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalToConstant: 60),
            logoView.widthAnchor.constraint(equalToConstant: 60),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapLoginButton() {
        performSegue(withIdentifier: Constants.Segues.webView, sender: nil)
    }
}


extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ webViewViewController: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        fetchOAuthToken(code: code)
    }
 
    // TODO: Подумать над надобностью
//    func webViewViewControllerDidCancel(_ webViewViewController: WebViewViewController) {
//        navigationController?.popViewController(animated: true)
//    }
    
    private func fetchOAuthToken(code: String) {
        UIBlockingProgressHUD.show()
        
        oauthService.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let token):
                storage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("\(Constants.Errors.failedFetchToken) - \(error)")
            }
        }
    }
}
