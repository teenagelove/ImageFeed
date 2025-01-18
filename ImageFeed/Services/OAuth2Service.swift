import Foundation


final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthRequest(code: code) else {
            print(Constants.Errors.failedRequest)
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = response.accessToken
                    completion(.success(response.accessToken))
                } catch {
                    print(Constants.Errors.failedDecode)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                print(Constants.Errors.failedFetch)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func makeOAuthRequest(code: String) -> URLRequest? {
        
        guard var urlComponents = URLComponents(url: Constants.API.defaultBaseURL, resolvingAgainstBaseURL: false) else {
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
