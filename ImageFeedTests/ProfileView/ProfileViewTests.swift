import XCTest
@testable import ImageFeed


final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()

        viewController.presenter = presenter
        presenter.view = viewController

        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsDisplayProfile() {
        let viewController = ProfileViewControllerSpy()
        let mockProfileService = MockProfileService()
        let presenter = ProfileViewPresenter(
            profileService: mockProfileService
        )

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()

        XCTAssertTrue(viewController.displayProfileDataCalled)
        XCTAssertEqual(viewController.displayedName, mockProfileService.profile?.name)
        XCTAssertEqual(viewController.displayedLogin, mockProfileService.profile?.loginName)
        XCTAssertEqual(viewController.displayedDescription, mockProfileService.profile?.bio)
        
    }

    func testPresenterCallsDownloadAvatar() {
        let viewController = ProfileViewControllerSpy()
        let mockProfileService = MockProfileService()
        let mockImageService = MockProfileImageService()
        let presenter = ProfileViewPresenter(
            profileService: mockProfileService,
            imageService: mockImageService
        )

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()

        XCTAssertTrue(viewController.downloadAvatarCalled)
        XCTAssertEqual(viewController.avatarURL, mockImageService.avatarURL)
    }
}
