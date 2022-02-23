//
//  OBTabBarController.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-12.
//

import UIKit

class OBTabBarController: UITabBarController {

    override func viewDidLoad() {
        UITabBar.appearance().tintColor = .systemRed
        viewControllers = [createHomeNC(), createScheduleNC(), createFriendRequestNC()]
    }
    
    func createHomeNC() -> UINavigationController{
        let homeVC = HomeVC()
        homeVC.title = "Home"
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        let NC = UINavigationController(rootViewController: homeVC)
        NC.navigationBar.tintColor = .systemRed
        return NC
    }
    
    
    func createScheduleNC() -> UINavigationController{
        let scheduleVC = ScheduleVC()
        scheduleVC.title = "Breaks"
        scheduleVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "calendar"), tag: 0)
        let NC = UINavigationController(rootViewController: scheduleVC)
        NC.navigationBar.tintColor = .systemRed
        return NC
    }
    
    func createFriendRequestNC() -> UINavigationController{
        let friendRequestsVC = FriendRequestsVC()
        friendRequestsVC.title = "Requests"
        friendRequestsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill.badge.plus"), tag: 0)
        let NC = UINavigationController(rootViewController: friendRequestsVC)
        NC.navigationBar.tintColor = .systemRed
        return NC
    }

}
