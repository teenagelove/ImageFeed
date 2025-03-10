import UIKit

final class TableViewMock: UITableView {
    var insertedIndexPaths: [IndexPath] = []
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        insertedIndexPaths.append(contentsOf: indexPaths)
    }
}
