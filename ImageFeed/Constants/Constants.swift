import UIKit


enum Constants {
    enum Date {
        static let defaultDateFormat = "dd MMMM yyyy"
        static let defaultLocale = "ru_RU"
    }

    enum Error {
        static let failedCast = "Failed to cast ImagesListCell"
        static let failedImage = "Failed to load image"
        static let failedSegue = "Invalid segue destination"
    }

    enum Image {
        static let activeLike = "Active Like"
        static let noActiveLike = "No Active Like"
        static let stubPhoto = "Stub Photo"
        static let exitProfile = "Exit"
    }

    enum UI {
        static let tableViewContentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let cellImageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
    
    enum Segues {
        static let singleImage = "ShowSingleImage"
    }
    
    enum ZoomScale {
        static let minimum = 0.1
        static let maximum = 1.25
    }
    
    enum MockText {
        static let name = "Екатерина Новикова"
        static let loginName = "@ekaterina_nov"
        static let description = "Hello, World!"
    }
    
    enum Font {
        static let header = UIFont.systemFont(ofSize: 23, weight: .semibold)
        static let regular = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
}
