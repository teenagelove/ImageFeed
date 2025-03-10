import Foundation
@testable import  ImageFeed


final class ImagesListCellDummy: ImagesListCellProtocol {
    var isLiked: Bool = false
    var configCellCalled = false
    
    func configCell(cellImageURL: URL, isLiked: Bool, dateString: String, completion: (() -> Void)?) {
        configCellCalled = true
    }
    
    func setIsLiked(isLike: Bool) {
        isLiked = isLike
    }
}
