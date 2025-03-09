import UIKit
@preconcurrency import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    // MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
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
        presenter?.setupWebView()
    }
    
    func setupObservers() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress) {[weak self] webView,_ in
            self?.presenter?.didUpdateProgressValue(webView.estimatedProgress)
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
        guard let url = navigationAction.request.url else { return nil }
        return presenter?.code(from: url)
    }
}

// MARK: - WebViewViewControllerProtocol
extension WebViewViewController {
    func load(request: URLRequest) {
        webView.load(request)
    }
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}
