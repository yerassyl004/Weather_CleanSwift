//
//  ContainerViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 09.01.2024.
//

import UIKit

class ContainerViewController: UIViewController{
    

    
    enum MenuState {
        case opened
        case closed
    }
    
    
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = ViewController()
    
    var navVC: UINavigationController?
    var centerController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        addChildVC()
    }
    
    
    
    func addChildVC() {
        
        
//        let nav = UINavigationController(rootViewController: menuVC)
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        menuVC.delegate = self
//        homeVC.delegateHome = self
//        menuVC.delegateData = homeVC
        homeVC.manageVCDelegate = menuVC
        
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        homeVC.delegate = self
        self.navVC = navVC
        
    }

}

extension ContainerViewController: HomeViewControllerDelegate {
    func menuButtonDidTapped() {
        
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.navVC?.view.frame.origin.x = (self.navVC?.view.frame.size.width)! - 100
                self.menuVC.view.frame.origin.x = 0
            } completion: { done in
                if done {
                    self.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.navVC?.view.frame.origin.x = 0
                self.menuVC.view.frame.origin.x = (self.navVC?.view.frame.origin.x ?? 0) - self.menuVC.view.frame.size.width
            } completion: { done in
                if done {
                    self.menuState = .closed
                }
            }
        }
    }
}

extension ContainerViewController: ManageDelegate {
    func didTapped() {
        print("Did tapped")
//        menuButtonDidTapped()
//        print("Did tapped")
//        let vc = ManageViewController()
//        homeVC.addChild(vc)
//        homeVC.view.addSubview(vc.view)
//        vc.view.frame = view.frame
//        vc.didMove(toParent: homeVC)
        
        //        print("tapped")
        //        // Handle the menu item selection
        //        menuButtonDidTapped()
        //        let manageVC = ManageViewController() // Replace with your actual view controller
        //        navVC?.pushViewController(manageVC, animated: true)
        //        present(ManageViewController(), animated: true)
    }
}
