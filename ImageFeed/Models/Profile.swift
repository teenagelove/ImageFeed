struct ProfileResult: Decodable {
    let username: String
    let name: String
    let bio: String?
}

struct Profile {
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        name = profileResult.name
        loginName = "@\(profileResult.username)"
        bio = profileResult.bio ?? ""
    }
}
