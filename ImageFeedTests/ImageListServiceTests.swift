@testable import ImageFeed
import XCTest


final class ImageFeedTests: XCTestCase {
    func testFetchPhotosNextPage() throws {
        let service = ImagesListService.shared
        
        let expectation1 = self.expectation(description: "Wait for first page notification")
        let expectation2 = self.expectation(description: "Wait for second page notification")
        
        var notificationCount = 0
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            notificationCount += 1
            if notificationCount == 1 {
                expectation1.fulfill()
            } else if notificationCount == 2 {
                expectation2.fulfill()
            }
        }
        
        service.fetchPhotosNextPage()
        
        wait(for: [expectation1], timeout: 10)
        
        service.fetchPhotosNextPage()
        
        wait(for: [expectation2], timeout: 10)
        
        print(service.photos.count)
        XCTAssertEqual(service.photos.count, 20)
    }
}
