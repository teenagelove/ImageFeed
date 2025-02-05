struct UserResult: Decodable {
    let profileImage: profileImage?
    
    struct profileImage: Decodable {
        let medium: String?
    }
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
