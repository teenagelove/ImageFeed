import UIKit
import WebKit


final class WebViewViewController: UIViewController {
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

