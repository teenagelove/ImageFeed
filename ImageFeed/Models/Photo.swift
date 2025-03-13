import Foundation


struct Photo {
    static let dateFormatter = ISO8601DateFormatter()
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let smallImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        id = photoResult.id
        size = CGSize(width: photoResult.width, height: photoResult.height)
        
        if let stringDate = photoResult.createdAt {
            createdAt = Photo.dateFormatter.date(from: stringDate)
        } else {
            createdAt = nil
        }
        
        welcomeDescription = photoResult.description
        smallImageURL = photoResult.urls.small
        largeImageURL = photoResult.urls.full
        isLiked = photoResult.likedByUser
    }
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

extension PhotoResult {
    struct UrlsResult: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}

extension Photo {
    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, smallImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.smallImageURL = smallImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
