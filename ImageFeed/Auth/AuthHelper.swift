import Foundation


protocol AuthHelperProtocol {
    var authURLRequest: URLRequest? { get }
    func getAuthURL() -> URL?
    func getCode(from url: URL) -> String?
}

final class AuthHelper {
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}


// MARK: - AuthHelperProtocol
extension AuthHelper: AuthHelperProtocol {
    var authURLRequest: URLRequest? {
       guard let url = getAuthURL() else { return nil }
       return URLRequest(url: url)
    }
    
    func getAuthURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            print(Constants.Errors.failedURL)
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope),
        ]
        
        return urlComponents.url
    }
    
    func getCode(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == configuration.oauthPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        else { return nil }
        return codeItem.value
    }
}
