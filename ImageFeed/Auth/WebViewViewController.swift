import UIKit
@preconcurrency import WebKit


final class WebViewViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - UI Components
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .ypWhite
        return webView
    }()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        setupView()
        setupSubviews()
        setupWebView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    private func setupWebView() {
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (
            WKNavigationActionPolicy
        ) -> Void
    ) {
        if let code = code(from: navigationAction) {
            //TODO: process code
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
            print(Constants.Errors.failedGetCode)
            return nil
        }
        return codeItem.value
    }
}
