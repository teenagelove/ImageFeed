import UIKit


enum Constants {
    enum Date {
        static let defaultDateFormat = "dd MMMM yyyy"
        static let defaultLocale = "ru_RU"
    }

    enum Error {
        static let failedCast = "Failed to cast ImagesListCell"
        static let failedImage = "Failed to load image"
    }

    enum Image {
        static let activeLike = "Active Like"
        static let noActiveLike = "No Active Like"
    }

    enum UI {
        static let tableViewContentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let cellImageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
}
