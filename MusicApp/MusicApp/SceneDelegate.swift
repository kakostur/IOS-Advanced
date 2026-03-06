//
//  SceneDelegate.swift
//  MusicApp
//
//  Created by Karakat Tursynbayeva on 06.03.2026.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: AppRouter?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navController = UINavigationController()
        let appRouter = AppRouter(navigationController: navController)
        appRouter.start()
        self.router = appRouter

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
