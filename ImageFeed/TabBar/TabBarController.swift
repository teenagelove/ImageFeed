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
        
    }
    
    func setupControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: Constants.Images.activeProfile),
            selectedImage: nil
        )
        
        viewControllers = [imagesListViewController, profileViewController]
    }
}
