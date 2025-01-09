import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Public properties
    var image: UIImage?
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    // MARK: - @IBActions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
}
