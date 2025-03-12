import Foundation

protocol ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func updateTableViewAnimated()
    func calculateCellHeight(for indexPath: IndexPath) -> CGFloat
    func numbersOfRowsInSection() -> Int
    func willDisplayCell(at indexPath: IndexPath)
    func configureSingleView(for indexPath: IndexPath) -> SingleImageViewController?
    func configCell(for cell: ImagesListCellProtocol, with indexPath: IndexPath)
    func didTapLikeButton(_ cell: ImagesListCellProtocol, completion: @escaping () -> Void)
}

final class ImagesListViewPresenter: ImageListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo]
    private let imagesListService: ImagesListServiceProtocol
    private let currentDate = Date()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Date.defaultDateFormat
        formatter.locale = Locale(identifier: Constants.Date.defaultLocale)
        return formatter
    }()
    
    init(
        imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    ) {
        self.imagesListService = imagesListService
        self.photos = imagesListService.photos
    }
}

// MARK: - ImagesListViewPresenterProtocol
extension ImagesListViewPresenter {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count

        photos = imagesListService.photos

        if oldCount < newCount {
            view?.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map {
                    IndexPath(row: $0, section: 0)
                }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }

    func calculateCellHeight(for indexPath: IndexPath) -> CGFloat {
        guard let view else { return 0 }
        let image = photos[indexPath.row]

        let imageInsets = Constants.UI.cellImageInsets
        let imageViewWidth =
            view.tableView.frame.width - imageInsets.left - imageInsets.right
        let cellHeight =
            image.size.height * (imageViewWidth / image.size.width)
            + imageInsets.top + imageInsets.bottom

        return cellHeight
    }

    func numbersOfRowsInSection() -> Int {
        return photos.count
    }

    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIBlockingProgressHUD.dismiss()
        }
        
        let testMode = ProcessInfo.processInfo.arguments.contains("TestMode")
        if testMode { return }
        
        guard indexPath.row == photos.count - 1 else { return }
        imagesListService.fetchPhotosNextPage()
    }

    func configureSingleView(for indexPath: IndexPath) -> SingleImageViewController? {
        guard
            let imageURL = URL(string: photos[indexPath.row].largeImageURL)
        else {
            print(Constants.Errors.failedImage)
            return nil
        }

        let singleImageViewController = SingleImageViewController()
        singleImageViewController.downloadImage(url: imageURL)
        singleImageViewController.modalPresentationStyle = .fullScreen

        return singleImageViewController
    }

    func configCell(for cell: ImagesListCellProtocol, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard
            let imageURL = URL(string: photo.smallImageURL)
        else {
            print(Constants.Errors.failedImage)
            return
        }

        cell.configCell(
            cellImageURL: imageURL,
            isLiked: photo.isLiked,
            dateString: dateFormatter.string(
                from: photo.createdAt ?? currentDate)
        ) { [weak self] in
            self?.view?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didTapLikeButton(_ cell: ImagesListCellProtocol, completion: @escaping () -> Void) {
        guard
            let cell = cell as? ImagesListCell,
            let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLike: !photo.isLiked)
            case .failure(let error):
                print("\(Constants.Errors.failedToChangeLike)\n\(error.localizedDescription)")
                completion()
            }
        }
    }
}
