struct ProfileResult: Decodable {
    let username: String
    let name: String
    let bio: String?
}

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    
    init(from profileResult: ProfileResult) {
        username = profileResult.username
        name = profileResult.name
        loginName = "@\(profileResult.username)"
        bio = profileResult.bio ?? ""
    }
}

// MARK: - Public Inits
public extension Profile {
    init(username: String, name: String, loginName: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}
