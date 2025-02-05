import Foundation


final class ProfileImageService {
    // MARK: - Singleton
    static let shared = ProfileImageService()
    
    // MARK: - Notification
    static let didChangeNotification = Notification.Name("ProfileImageServiceDidChange")
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    // MARK: - Init
    private init() {}
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        guard let request = makeRequest(username: username) else {
            print(Constants.Errors.failedRequest)
            completion(.failure(Constants.NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let response):
                guard let profileImageURL = response.profileImage?.medium else { return }
                self?.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(
                    name: Self.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            case .failure(let error):
                print("\(Constants.Errors.failedFetchData)\n\(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(username: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: Constants.API.baseAPIUrl)
        else {
            print(Constants.Errors.failedRequest)
            return nil
        }
        
        urlComponents.path = Constants.API.usersPath + "/" + username
        
        guard let url = urlComponents.url else {
            print(Constants.Errors.failedURL)
            return nil
        }
        
        var request = URLRequest(url: url)
        
        guard let token = storage.token else {
            print(Constants.Errors.failedGetToken)
            return nil
        }
        
        request.setValue(
            Constants.API.bearer + token,
            forHTTPHeaderField: Constants.API.authorizationHeader
        )
        
        return request
    }
}
