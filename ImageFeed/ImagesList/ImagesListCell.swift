import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradientForTextArea()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(
            x: 0,
            y: cellImage.frame.midY,
            width: cellImage.bounds.width,
            height: 30
        )
    }
    
    private func setupGradientForTextArea() {
        gradientLayer.colors = [
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0).cgColor,
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2).cgColor
        ]
        
        gradientLayer.cornerRadius = 5
        
        cellImage.layer.addSublayer(gradientLayer)
    }
}
