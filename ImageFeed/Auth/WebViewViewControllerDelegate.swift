protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ webViewViewController: WebViewViewController, didAuthenticateWithCode code: String)
}
