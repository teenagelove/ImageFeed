import Foundation
import ImageFeed


final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadCalled: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    
    func setProgressHidden(_ isHidden: Bool) { }
}
