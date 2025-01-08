import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction private func didTapLogoutButton() {
        // TODO: - Добавить функцию выхода из профиля.
    }
}
