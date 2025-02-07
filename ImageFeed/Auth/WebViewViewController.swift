import UIKit
@preconcurrency import WebKit


final class WebViewViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: -Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - UI Components
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .ypWhite
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypBlack
        return progressView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupWebView()
        setupObservers()
        setupConstraints()
    }
}

// MARK: - Setup & Update Methods
private extension WebViewViewController {
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupSubviews() {
        [webView, progressView].forEach{ subViews in
            subViews.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subViews)
        }
    }
    
    func setupWebView() {
        webView.navigationDelegate = self
        
        guard var urlComponents = URLComponents(string: Constants.API.unsplashAuthorizeURLString) else {
            print(Constants.Errors.failedURL)
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.API.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.API.accessScope),
        ]
        
        guard let url = urlComponents.url else {
            print(Constants.Errors.failedURL)
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func setupObservers() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress) {[weak self] _,_ in
            self?.updateProgressView()
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func updateProgressView() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }
}


// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (
            WKNavigationActionPolicy
        ) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.API.oauthPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        else {
            return nil
        }
        return codeItem.value
    }
}
