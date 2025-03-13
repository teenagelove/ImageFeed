@testable import ImageFeed


final class MockProfileImageService: ProfileImageServiceProtocol {
    var avatarURL: String? = "ya.ru"
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, any Error>) -> Void) { }
    
    func clearProfileImage() { }
}
