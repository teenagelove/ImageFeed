import Foundation


final class OAuth2Service {
    // MARK: - Singleton
    static let shared = OAuth2Service()
    
    // MARK: - Private properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Init
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(Constants.NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        lastCode = code
        
        guard
            let request = makeOAuthRequest(code: code)
        else {
            print(Constants.Errors.failedRequest)
            completion(.failure(Constants.NetworkError.invalidRequest))
            return
        }
        
       let task = urlSession.objectTask(for: request) {[weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.accessToken))
            case .failure(let error):
                print("\(Constants.Errors.failedFetchData)\n\(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastCode = nil
        }
        
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthRequest(code: String) -> URLRequest? {
        guard let url = Constants.API.defaultBaseURL, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print(Constants.Errors.failedURL)
            return nil
        }
        
        urlComponents.path = Constants.API.tokenPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.API.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.API.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.API.authorizationCodeString)
        ]
         
        guard let url = urlComponents.url else {
            print(Constants.Errors.failedURL)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
