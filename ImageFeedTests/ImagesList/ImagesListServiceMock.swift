import Foundation
@testable import ImageFeed

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = [Photo(
        id: "1",
        size: CGSize(width: 100, height: 200),
        createdAt: Date(),
        welcomeDescription: "Description",
        smallImageURL: "ya.ru",
        largeImageURL: "ya.ru",
        isLiked: false
    )]
    
    var calledFetchPhotosNextPage = false
    
    func clearImagesList() { }
    
    func fetchPhotosNextPage() {
        calledFetchPhotosNextPage = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) { }
}
