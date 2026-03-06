import Foundation

// MusicService
final class MusicService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    //Fetch Albums

    func fetchAlbums(query: String = "top hits") async throws -> [Album] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://itunes.apple.com/search?term=\(encodedQuery)&entity=album&limit=25"

        guard let url = URL(string: urlString) else {
            throw MusicServiceError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw MusicServiceError.badResponse
        }

        let decoded = try JSONDecoder().decode(iTunesResponse.self, from: data)

        return decoded.results
            .filter { $0.wrapperType == "collection" }
            .map { Album(from: $0) }
    }

    // Fetch Tracks

    func fetchTracks(for album: Album) async throws -> [Track] {
        let urlString = "https://itunes.apple.com/lookup?id=\(album.id)&entity=song"

        guard let url = URL(string: urlString) else {
            throw MusicServiceError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw MusicServiceError.badResponse
        }

        let decoded = try JSONDecoder().decode(iTunesResponse.self, from: data)

        return decoded.results
            .filter { $0.wrapperType == "track" }
            .sorted { ($0.trackNumber ?? 0) < ($1.trackNumber ?? 0) }
            .map { Track(from: $0) }
    }
}

// Errors
enum MusicServiceError: LocalizedError {
    case invalidURL
    case badResponse
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:    return "Invalid URL"
        case .badResponse:   return "Server returned an error"
        case .decodingError: return "Failed to parse response"
        }
    }
}
