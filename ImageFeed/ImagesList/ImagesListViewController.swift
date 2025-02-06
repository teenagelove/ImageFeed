import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let currentDate = Date()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Date.defaultDateFormat
        formatter.locale = Locale(identifier: Constants.Date.defaultLocale)
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = Constants.UI.tableViewContentInsets
    }
}

private extension ImagesListViewController {
    // MARK: - Private Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            print(Constants.Errors.failedImage)
            return
        }
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        
        let likeImage = indexPath.row.isEven
        ? UIImage(named: Constants.Images.activeLike)
        : UIImage(named: Constants.Images.noActiveLike)
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToSingleImage(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = Constants.UI.cellImageInsets
        let imageViewWidth = tableView.frame.width - imageInsets.left - imageInsets.right
        let cellHeight = image.size.height * (imageViewWidth / image.size.width) + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    private func navigateToSingleImage(at indexPath: IndexPath) {
        let image = UIImage(named: photosName[indexPath.row])
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.image = image
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imagesListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            print(Constants.Errors.failedCast)
            return UITableViewCell()
        }
        
        configCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
}
