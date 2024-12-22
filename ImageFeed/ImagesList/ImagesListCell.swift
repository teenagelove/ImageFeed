import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradientForTextArea()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = gradientView.bounds
    }
    
    private func setupGradientForTextArea() {
        gradientLayer.colors = [
            UIColor.ypBlack.withAlphaComponent(0).cgColor,
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
        ]
        
        gradientLayer.cornerRadius = 5
        
        gradientView.layer.addSublayer(gradientLayer)
    }
}
