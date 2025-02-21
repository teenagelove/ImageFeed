import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.minimumZoomScale = Constants.ZoomScale.minimum
        view.maximumZoomScale = Constants.ZoomScale.maximum
        view.delegate = self
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Constants.Images.backButton), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sharingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Constants.Images.sharingButton), for: .normal)
        button.addTarget(self, action: #selector(didTapSharingButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Public Methods
extension SingleImageViewController {
    func downloadImage(url: URL) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(
                named: Constants.Images.unsplashLoader
            )
        ) { [weak self] _ in
            self?.configureImageView()
        }
    }
}

private extension SingleImageViewController {
    // MARK: - Setup Methods
    func setupUI() {
        setupView()
        setupSubviews()
        setupConstraints()
        configureImageView()
    }
    
    func setupView() {
        view.backgroundColor = .ypBlack
    }
    
    func configureImageView() {
        guard isViewLoaded, let image = imageView.image else { return }
        
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    func setupSubviews() {
        scrollView.addSubview(imageView)
        [scrollView, backButton, sharingButton].forEach{subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sharingButton.heightAnchor.constraint(equalToConstant: 51),
            sharingButton.widthAnchor.constraint(equalTo: sharingButton.heightAnchor),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: - Actions
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapSharingButton() {
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return imageView }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scrollViewSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        
        let offsetX = max((scrollViewSize.width - contentSize.width) / 2, 0)
        let offsetY = max((scrollViewSize.height - contentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(
            top: offsetY,
            left: offsetX,
            bottom: offsetY,
            right: offsetX
        )
    }
}
