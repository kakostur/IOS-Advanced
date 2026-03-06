import Foundation
import Observation

// AlbumsViewModel
@Observable
final class AlbumsViewModel {

    // State
    var albums: [Album] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var searchQuery: String = ""

    // Private
    private let service: MusicService
    private var currentQuery: String = "top hits"

    init(service: MusicService) {
        self.service = service
    }

    // Public Methods

    func loadAlbums() async {
        isLoading = true
        errorMessage = nil

        do {
            albums = try await service.fetchAlbums(query: currentQuery)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func search(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        currentQuery = trimmed
        await loadAlbums()
    }
}
