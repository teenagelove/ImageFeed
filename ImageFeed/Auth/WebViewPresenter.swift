import Foundation


protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func setupWebView()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func setupWebView() {
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
        
        didUpdateProgressValue(0)
        
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldProgressHidden = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldProgressHidden)
    }
    
    func code(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Constants.API.oauthPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        else { return nil }
        return codeItem.value
    }
}

private extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
