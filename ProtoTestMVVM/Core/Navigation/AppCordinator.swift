//
//  AppCordinator.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 21/05/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}
class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController = UINavigationController()
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    func start() { }
    
    func finish() {
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
    }
    // Helper method to add child coordinator
    func addChildCoordinator(_ coordinator: Coordinator) {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
}
class AppCoordinator: BaseCoordinator {
    override func start() {
        let loginCoordinator = AuthCoordinator(navigationController: navigationController)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
}
