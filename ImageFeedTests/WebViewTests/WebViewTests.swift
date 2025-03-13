import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()

        viewController.presenter = presenter
        presenter.view = viewController

        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelperDummy())

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()

        XCTAssertTrue(viewController.loadCalled)
    }

    func testProgressHiddenWhenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelperDummy())

        let shouldProgressHide = presenter.shouldHideProgress(for: 1.0)

        XCTAssertTrue(shouldProgressHide)
    }

    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        let url = authHelper.getAuthURL()
        
        guard let urlString = url?.absoluteString else {
            return XCTFail("Auth URL is nil")
        }
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        let authHelper = AuthHelper()
        let testCode = "test code"
        
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        else {
            return XCTFail("Failed to create URLComponents")
        }
        urlComponents.queryItems = [URLQueryItem(name: "code", value: testCode)]
        
        guard let url = urlComponents.url else {
            return XCTFail("Failed to create URL")
        }
        
        let code = authHelper.getCode(from: url)
        
        XCTAssertEqual(testCode, code)
    }
}
