import Foundation
import Observation

// TracksViewModel
@Observable
final class TracksViewModel {

    //  State
    let album: Album
    var tracks: [Track] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // Private
    private let service: MusicService

    init(album: Album, service: MusicService) {
        self.album = album
        self.service = service
    }

    // Public Methods

    func loadTracks() async {
        isLoading = true
        errorMessage = nil

        do {
            tracks = try await service.fetchTracks(for: album)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
