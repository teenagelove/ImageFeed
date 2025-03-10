import UIKit
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol?
    var tableView = UITableView()
    var updateTableViewAnimatedCalled = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    // Реализуйте остальные методы протокола, если необходимо
}
