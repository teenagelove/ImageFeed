import XCTest

enum Credentials {
    // Enter your data here
    static let login = ""
    static let password = ""
}

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        logoutIfSessionExists()
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        typeToTextField(loginTextField, text: Credentials.login)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        typeToTextField(passwordTextField, text: Credentials.password)
        
        // Swipe up to reveal the login button
        webView.swipeUp()
        
        app.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        
    }
}

private extension ImageFeedUITests {
    func logoutIfSessionExists() {
        if !app.buttons["Authenticate"].exists {
            app.tabBars.buttons["Profile"].tap()
            app.buttons["Logout"].tap()
            app.alerts["Bye, bye!"].scrollViews.otherElements.buttons["Yes"].tap()
        }
    }
    
    func typeToTextField(_ textField: XCUIElement, text: String) {
        textField.tap()
        textField.typeText(text)
        app.tap()
    }
}
