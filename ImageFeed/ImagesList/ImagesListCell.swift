import UIKit
import Kingfisher

protocol ImagesListCellProtocol {
    func configCell(cellImageURL: URL, isLiked: Bool, dateString: String, completion: (() -> Void)?)
    func setIsLiked(isLike: Bool)
}

// MARK: - Delegate Protocol
protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCellProtocol)
}

final class ImagesListCell: UITableViewCell & ImagesListCellProtocol {
    // MARK: - Public properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Delegate
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UI Components
    private lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 15
        cellImage.backgroundColor = .ypGray
        return cellImage
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Constants.Images.noActiveLike), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        button.setImage(UIImage(named: Constants.Images.noActiveLike), for: .normal)
        button.accessibilityIdentifier = Constants.AccessibilityIdentifiers.likeButton
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regular
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var gradientView = GradientView()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(cellImageURL: URL, isLiked: Bool, dateString: String, completion: (() -> Void)? = nil) {
        self.cellImage.kf.indicatorType = .activity
        self.cellImage.kf.setImage(
            with: cellImageURL,
            placeholder: UIImage(named: Constants.Images.unsplashLoader)
        ) { _ in
            completion?()
        }
        setIsLiked(isLike: isLiked)
        self.dateLabel.text = dateString
    }
}

// MARK: - Public Methods
extension ImagesListCell {
    func setIsLiked(isLike: Bool) {
        let image = isLike
        ? UIImage(named: Constants.Images.activeLike)
        : UIImage(named: Constants.Images.noActiveLike)
        likeButton.setImage(image, for: .normal)
    }
}

private extension ImagesListCell {
    // MARK: - Setup Methods
    func setupUI() {
        contentView.backgroundColor = .ypBlack
        self.selectionStyle = .none
        self.backgroundColor = .ypBlack
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        [cellImage, gradientView, likeButton, dateLabel].forEach { subviews in
            subviews.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subviews)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc func didTapLikeButton() {
        delegate?.imageListCellDidTapLike(self)
    }
}
