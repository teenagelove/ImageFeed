protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ webViewViewController: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ webViewViewController: WebViewViewController)
}
