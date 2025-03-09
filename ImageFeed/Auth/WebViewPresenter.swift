import Foundation


public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    // MARK: - Initialize
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
}
// MARK: - Public Methods
extension WebViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

// MARK: - WebViewPresenterProtocol
extension WebViewPresenter {
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldProgressHidden = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldProgressHidden)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
