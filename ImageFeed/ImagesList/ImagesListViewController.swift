import UIKit


final class ImagesListViewController: UIViewController {
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = Constants.UI.tableViewContentInsets
        tableView.separatorStyle = .none
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Private properties
    private var photos = [Photo]()
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
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
        setupUI()
        UIBlockingProgressHUD.show()
    }
}

// MARK: - Setup Methods
private extension ImagesListViewController {
    func setupUI() {
        view.backgroundColor = .ypBlack
        setupSubviews()
        setupConstraints()
        setupObservers()
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
    }
    
    func setupObservers() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
    }
}

// MARK: - Private Methods
private extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let imageURL = URL(string: photos[indexPath.row].thumbImageURL)
        else {
            print(Constants.Errors.failedImage)
            return
        }
        
        let likeImage = indexPath.row.isEven
        ? UIImage(named: Constants.Images.activeLike)
        : UIImage(named: Constants.Images.noActiveLike)
        
        cell.configCell(
            cellImageURL: imageURL,
            likeImage: likeImage,
            dateString: dateFormatter.string(from: currentDate)
        ) { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        if oldCount < newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToSingleImage(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = Constants.UI.cellImageInsets
        let imageViewWidth = tableView.frame.width - imageInsets.left - imageInsets.right
        let cellHeight = image.size.height * (imageViewWidth / image.size.width) + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    private func navigateToSingleImage(at indexPath: IndexPath) {
        guard
            let imageURL = URL(string: photos[indexPath.row].largeImageURL)
        else {
            print(Constants.Errors.failedImage)
            return
        }
        
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.downloadImage(url: imageURL)
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIBlockingProgressHUD.dismiss()
        }
        guard indexPath.row == photos.count - 1 else { return }
        imagesListService.fetchPhotosNextPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell
            
        else {
            return ImagesListCell(style: .default, reuseIdentifier: ImagesListCell.reuseIdentifier)
        }
            
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
