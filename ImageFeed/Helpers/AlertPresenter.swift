import UIKit


final class AlertPresenter {
    static func showAlert(vc: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alertController, animated: true)
    }
}
