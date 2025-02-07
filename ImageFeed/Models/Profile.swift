struct ProfileResult: Decodable {
    let username: String
    let name: String
    let bio: String?
}

struct Profile {
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
