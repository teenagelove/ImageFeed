import Foundation
@testable import ImageFeed

final class AuthHelperDummy: AuthHelperProtocol {
    func authRequest() -> URLRequest? {
        guard let url = URL(string: "dzen.ru") else {
            return nil
        }
        return URLRequest(url: url)
    }

    func authURL() -> URL? { return nil }

    func code(from url: URL) -> String? { return nil }
}
