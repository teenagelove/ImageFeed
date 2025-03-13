import UIKit
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol?
    var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
}
