import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - @IBOutlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Public properties
    static let reuseIdentifier = "ImagesListCell"
}
