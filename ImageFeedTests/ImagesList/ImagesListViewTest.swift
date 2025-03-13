import XCTest

@testable import ImageFeed

final class ImagesListViewPresenterTests: XCTestCase {

    func testUpdateTableViewAnimated() {
        let imagesListService = ImagesListServiceMock()
        let mockTableView = TableViewMock()
        let viewController = ImagesListViewControllerSpy()
        
        let presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        presenter.view = viewController
        viewController.tableView = mockTableView
        
        imagesListService.photos.append(Photo(
            id: "2",
            size: CGSize(width: 100, height: 200),
            createdAt: Date(),
            welcomeDescription: "Description",
            smallImageURL: "ya.ru",
            largeImageURL: "ya.ru",
            isLiked: false
        ))
        
        presenter.updateTableViewAnimated()
        
        XCTAssertEqual(presenter.photos.count, 2)
        XCTAssertEqual(mockTableView.insertedIndexPaths, [IndexPath(row: 1, section: 0)])
    }

    func testCalculateCellHeight() {
        let imagesListService = ImagesListServiceMock()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        let indexPath = IndexPath(row: 0, section: 0)
        let height = presenter.calculateCellHeight(for: indexPath)
        XCTAssertEqual(height, 144)
    }

    func testNumbersOfRowsInSection() {
        let imagesListService = ImagesListServiceMock()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        XCTAssertEqual(presenter.numbersOfRowsInSection(), 1)
    }

    func testWillDisplayCell() {
        let imagesListService = ImagesListServiceMock()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.willDisplayCell(at: indexPath)
        XCTAssertTrue(imagesListService.calledFetchPhotosNextPage)
    }
    
    func testConfigCellCalled() {
        let imagesListService = ImagesListServiceMock()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = ImagesListCellDummy()
        presenter.configCell(for: cell, with: indexPath)
        XCTAssertTrue(cell.configCellCalled)
    }

    func testTableViewNumberOfRowsInSection() {
        let imagesListService = ImagesListServiceMock()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListService)
        let viewController = ImagesListViewController()
        presenter.view = viewController
        viewController.presenter = presenter
        let tableView = viewController.tableView
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, presenter.numbersOfRowsInSection())
    }

    func testImageListCellDidTapLike() {
        let presenter = ImagesListViewPresenterSpy()
        let viewController = ImagesListViewController()
        presenter.view = viewController
        viewController.presenter = presenter
        let cell = ImagesListCellDummy()
        viewController.imageListCellDidTapLike(cell)
        XCTAssertTrue(presenter.didTapLikeButtonCalled)
    }
}
