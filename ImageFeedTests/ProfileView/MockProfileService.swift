@testable import ImageFeed


final class MockProfileService: ProfileServiceProtocol {
    var profile: Profile? = Profile(
        username: "Test Username",
        name: "Test Name",
        loginName: "Test login Name",
        bio: "Mock bio"
    )
    
    func fetchProfile(
        token: String,
        completion: @escaping (
            Result<ImageFeed.Profile, any Error>
        ) -> Void
    ) { }
    
    func clearProfile() { }
}
