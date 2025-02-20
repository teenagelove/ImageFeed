import Foundation


final class ImagesListService {
    // MARK: - Singleton
    static let shared = ImagesListService()
    
    // MARK: - Notification
    static let didChangeNotification = Notification.Name(Constants.Notifications.imagesListServiceDidChange)
    
    // MARK: - Properties
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage.shared
    
    // MARK: - Init
    private init() {}
    
    func fetchPhotosNextPage() {
        guard task == nil else {
            print(Constants.Errors.taskIsRunning)
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequest(page: nextPage) else {
            print(Constants.Errors.failedRequest)
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.lastLoadedPage = nextPage
                self.photos.append(contentsOf: response.map(Photo.init))
                NotificationCenter.default.post(
                    name: Self.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": response]
                )
            case .failure(let error):
                print("\(Constants.Errors.failedFetchData)\n\(error.localizedDescription)")
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(page: Int) -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: Constants.API.baseAPIUrl)
        else {
            print(Constants.Errors.failedRequest)
            return nil
        }
        
        urlComponents.path = Constants.API.photosPath
        urlComponents.queryItems = [
            URLQueryItem(name: Constants.API.pageQuery, value: String(page)),
            URLQueryItem(name: Constants.API.perPageQuery, value: Constants.API.perPageValue)
        ]
        
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
