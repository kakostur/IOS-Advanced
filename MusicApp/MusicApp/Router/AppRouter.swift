import UIKit
import SwiftUI

// Router Protocol
protocol RouterProtocol: AnyObject {
    func start()
    func showTracks(for album: Album)
    func showPlayer(for track: Track, in tracks: [Track])
}

//  AppRouter
final class AppRouter: RouterProtocol {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationAppearance()
    }

    // RouterProtocol

    func start() {
        let viewModel = AlbumsViewModel(service: MusicService())
        var view = AlbumsView(viewModel: viewModel)

        view.onAlbumSelected = { [weak self] album in
            self?.showTracks(for: album)
        }

        let hostingController = UIHostingController(rootView: view)
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func showTracks(for album: Album) {
        let viewModel = TracksViewModel(album: album, service: MusicService())
        var view = TracksView(viewModel: viewModel)

        view.onTrackSelected = { [weak self] track, allTracks in
            self?.showPlayer(for: track, in: allTracks)
        }

        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }

    func showPlayer(for track: Track, in tracks: [Track]) {
        let viewModel = PlayerViewModel(track: track, tracks: tracks)
        let view = PlayerView(viewModel: viewModel)

        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }

    // Private

    private func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = true
    }
}
