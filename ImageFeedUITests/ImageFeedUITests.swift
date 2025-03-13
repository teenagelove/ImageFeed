import XCTest
@testable import ImageFeed


enum Credentials {
    // Enter your data here
    static let login = "login/email"
    static let password = "password"
    static let name = "Full Name"
    static let loginName = "@loginName"
}

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["TestMode"]
        app.launch()
    }

    func testAuth() throws {
        logoutIfSessionExists()

        app.buttons[Constants.AccessibilityIdentifiers.loginButton].tap()

        let webView = app.webViews[Constants.AccessibilityIdentifiers.webView]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        typeToTextField(loginTextField, text: Credentials.login)

        let passwordTextField = webView.descendants(matching: .secureTextField)
            .element
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
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 20))
        cell.swipeUp()

        let cellToLike = tablesQuery.children(matching: .cell).element(
            boundBy: 4)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 10))

        cellToLike.buttons[Constants.AccessibilityIdentifiers.likeButton].tap()

        let progressHUD = app.activityIndicators.progressIndicators.element
        XCTAssertFalse(progressHUD.waitForExistence(timeout: 5))

        cellToLike.buttons[Constants.AccessibilityIdentifiers.likeButton].tap()
        XCTAssertFalse(progressHUD.waitForExistence(timeout: 5))
        
        cellToLike.tap()

        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let backButton = app.buttons[Constants.AccessibilityIdentifiers.singleBackButton]
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        backButton.tap()
    }

    func testProfile() throws {
        app.tabBars.buttons[Constants.AccessibilityIdentifiers.profile].tap()
        
        XCTAssertTrue(app.staticTexts[Credentials.name].exists)
        XCTAssertTrue(app.staticTexts[Credentials.loginName].exists)
        
        logout()
        XCTAssertTrue(app.buttons[Constants.AccessibilityIdentifiers.loginButton].exists)
    }
}

extension ImageFeedUITests {
    fileprivate func logoutIfSessionExists() {
        if !app.buttons[Constants.AccessibilityIdentifiers.loginButton].exists {
            app.tabBars.buttons[Constants.AccessibilityIdentifiers.profile].tap()
            logout()
        }
    }

    fileprivate func typeToTextField(_ textField: XCUIElement, text: String) {
        textField.tap()
        textField.typeText(text)
        app.tap()
    }
    
    fileprivate func logout() {
        app.buttons[Constants.AccessibilityIdentifiers.logoutButton].tap()
        let alert = app.alerts["Bye, bye!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.scrollViews.otherElements.buttons["Yes"].tap()
    }
}
