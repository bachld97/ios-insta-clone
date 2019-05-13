//
//  HomeNavigationViewController.swift
//  Instagram Clone
//
//  Created by CPU12071 on 5/6/19.
//  Copyright © 2019 Le Duy Bach. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UITabBarController {
    
    private let loggedInUser: User
    
    init(user: User) {
        loggedInUser = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
    }

    private func setupTabBarItems() {
        viewControllers = setupViewControllers()
        removeTitles()
    }
    
    private func setupViewControllers() -> [UIViewController] {
//        let search = SearchScreenViewController(excluding: loggedInUser)
//        let create = CreateContentScreenViewController(of: loggedInUser)
//        let notification = NotificationScreenViewController(of: loggedInUser)
//        let profile = ProfileScreenViewController(of: loggedInUser)
        let feed = FeedScreenViewController(of: loggedInUser)
        let search = NewFeedScreenViewController(viewingAs: loggedInUser)
        let create = CreateScreenViewController()
        let notification = NotificationScreenViewController()
        let profile = ProfileScreenViewController()
        
        let feedNav = UINavigationController(rootViewController: feed)
        let searchNav = UINavigationController(rootViewController: search)
        let createNav = UINavigationController(rootViewController: create)
        let notificationNav = UINavigationController(rootViewController: notification)
        let profileNav = UINavigationController(rootViewController: profile)
        
        feedNav.tabBarItem.image =
            UIImage(named: "feed_unselected")?.withRenderingMode(.alwaysOriginal)
        feedNav.tabBarItem.selectedImage =
            UIImage(named: "feed")?.withRenderingMode(.alwaysOriginal)
        searchNav.tabBarItem.image =
            UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        searchNav.tabBarItem.selectedImage =
            UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        createNav.tabBarItem.image =
            UIImage(named: "create_unselected")?.withRenderingMode(.alwaysOriginal)
        createNav.tabBarItem.selectedImage =
            UIImage(named: "create")?.withRenderingMode(.alwaysOriginal)
        notificationNav.tabBarItem.image =
            UIImage(named: "noti_unselected")?.withRenderingMode(.alwaysOriginal)
        notificationNav.tabBarItem.selectedImage =
            UIImage(named: "noti")?.withRenderingMode(.alwaysOriginal)
        profileNav.tabBarItem.image =
            UIImage(named: "profile_unselected")?.withRenderingMode(.alwaysOriginal)
        profileNav.tabBarItem.selectedImage =
            UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        
        return [
            feedNav, searchNav, createNav, notificationNav, profileNav
        ]
    }
    
    private func removeTitles() {
        for item in self.tabBar.items ?? [] {
            item.title = nil
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -12, right: 0)
        }
    }
}
