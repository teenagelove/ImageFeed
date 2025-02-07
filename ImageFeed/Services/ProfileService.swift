import Foundation


final class ProfileService {
    // MARK: - Singleton
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Init
    private init() {}
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        guard let request = makeRequest(token: token) else {
            completion(.failure(Constants.NetworkError.invalidRequest))
            print(Constants.Errors.failedRequest)
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let response):
                    let newProfile = Profile(from: response)
                    self?.profile = newProfile
                    completion(.success(newProfile))
            case .failure(let error):
                print("\(Constants.Errors.failedFetchData)\n\(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: Constants.API.baseAPIUrl)
        else {
            print(Constants.Errors.failedRequest)
            return nil
        }
        
        urlComponents.path = Constants.API.mePath
        
        guard let url = urlComponents.url else {
            print(Constants.Errors.failedURL)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            Constants.API.bearer + token,
            forHTTPHeaderField: Constants.API.authorizationHeader
        )
        
        return request
    }
}
