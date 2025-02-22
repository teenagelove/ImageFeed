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
            handler: handler
        )
    }
    
    private static func showAlert(vc: UIViewController, title: String, message: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        if let handler {
            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                handler()
            }
            
            alertController.addAction(retryAction)
        }
        
        vc.present(alertController, animated: true)
    }
}
