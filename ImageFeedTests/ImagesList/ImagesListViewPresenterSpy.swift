import Foundation
@testable import ImageFeed

final class ImagesListViewPresenterSpy: ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var didTapLikeButtonCalled = false
    var configCellCalled = false
    var photos: [Photo] = []
    
    func updateTableViewAnimated() {
        
    }
    
    func calculateCellHeight(for indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func numbersOfRowsInSection() -> Int {
        0
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        
    }
    
    func configureSingleView(for indexPath: IndexPath) -> SingleImageViewController? {
        return nil
    }
    
    func configCell(for cell: ImagesListCellProtocol, with indexPath: IndexPath) {
        configCellCalled = true
    }
    
    func didTapLikeButton(_ cell: ImagesListCellProtocol, completion: @escaping () -> Void) {
        didTapLikeButtonCalled = true
    }
}
