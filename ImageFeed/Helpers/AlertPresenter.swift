import UIKit


final class AlertPresenter {
    static func showLikeAlert(vc: UIViewController) {
        showAlert(
            vc: vc,
            title: Constants.Errors.somethingWrong,
            message: Constants.Errors.failedToChangeLike
        )
    }
    
    static func showLoginAlert(vc: UIViewController) {
        showAlert(
            vc: vc,
            title: Constants.Errors.somethingWrong,
            message: Constants.Errors.failedEnter
        )
    }
    
    static func showLoadError(vc: UIViewController, handler: @escaping () -> Void) {
        showAlert(
            vc: vc,
            title: Constants.Errors.somethingWrong,
            message: Constants.Errors.failedToLoadImage,
            rightHandler: handler
        )
    }
    
    static func showLogoutWarning(vc: ProfileViewControllerProtocol, handler: @escaping () -> Void) {
        guard let vc = vc as? UIViewController else { return }
        showAlert(
            vc: vc,
            title: Constants.Alert.byeMessage,
            message: Constants.Alert.sureMessage,
            leftButton: Constants.Alert.yes,
            rightButton: Constants.Alert.cancel,
            leftHandler: handler
        )
    }
    
    private static func showAlert(
        vc: UIViewController,
        title: String,
        message: String,
        leftButton: String = Constants.Alert.ok,
        rightButton: String? = Constants.Alert.retry,
        leftHandler: (() -> Void)? = nil,
        rightHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: leftButton, style: .default) {_ in 
            leftHandler?()
        }
        alertController.addAction(okAction)
        
        if let rightButton {
            let secondAction = UIAlertAction(title: rightButton, style: .default) { _ in
                rightHandler?()
            }
            
            alertController.addAction(secondAction)
        }
        
        vc.present(alertController, animated: true)
    }
}
