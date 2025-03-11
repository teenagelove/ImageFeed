import UIKit


final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupControllers()
    }
}

private extension TabBarController {
    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
        tabBar.standardAppearance = appearance
        // TODO: - Не понятно как по другому убрать моргание таб бара при смене вкладок
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    func setupControllers() {
        
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListViewPresenter()
        
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: Constants.Images.imagesList),
            selectedImage: nil
        )
        imagesListViewController.tabBarItem.accessibilityIdentifier = Constants.AccessibilityIdentifiers.feed
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
        
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: Constants.Images.activeProfile),
            selectedImage: nil
        )
        profileViewController.tabBarItem.accessibilityIdentifier = Constants.AccessibilityIdentifiers.profile
        
        viewControllers = [imagesListViewController, profileViewController]
    }
}
